# == Schema Information
#
# Table name: vendors
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  legal_name         :string(255)
#  description        :string(255)
#  website            :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  default_tax_rate   :decimal(, )      default(0.0), not null
#  address_id         :integer
#  vendor_manager_id  :integer
#

class Vendor < ActiveRecord::Base
  include Fooda::Accounting
  include Fooda::Asset
  include Fooda::Search
  include SearchSortPaginate
  
  global_site_search on: [:name, :legal_name, :"id::varchar(255)"]

  acts_as_payable
  acts_as_billable

  has_many :inventory_items, :dependent => :destroy
  has_many :menu_templates, :dependent => :restrict
  has_many :event_vendors, :dependent => :restrict
  has_many :contacts, :dependent => :destroy

  has_many :product_types, :class_name => "VendorProductType", :dependent => :destroy
  has_many :products, :class_name => "VendorProduct", :dependent => :destroy
  has_many :issues, as: :subject
  has_images

  belongs_to :address
  belongs_to :vendor_manager, :class_name => "User"

  accepts_nested_attributes_for :address, allow_destroy: true

  validates_presence_of :name, :default_tax_rate, :cuisine_list, :vendor_manager_id
  validates_uniqueness_of :name

  default_scope order 'name'

  acts_as_ordered_taggable_on :cuisines

  after_initialize :initial_values

  after_create :create_product_type_records
  after_create :create_all_item_menu_templates

  has_attached_file :image,
    :storage => :fog,
    :default_url => '/images/default_vendor.gif',
    :fog_credentials => {
      provider: "AWS",
      aws_access_key_id: AWS::Key,
      aws_secret_access_key: AWS::Secret,
      region: AWS::Region
    },
    :fog_public => true,
    :fog_directory => AWS::PublicBucket,
    :path => ":id.:extension"

  def to_search_result
    super.merge(:preview => "Vendor: " + self.pretty_id)
  end

  def to_s
    name
  end

  def pretty_id
    "#{self.id.to_s.rjust(7, "0")}"
  end

  def has_product? product
    products.where(product:product).count > 0
  end

  def product_type_config
    @product_type_config ||= product_types.inject({}) do |memo,product_type|
      setting = memo[product_type.product_type] = {
        "status" => product_type.status
      }

      product_type.products.collect(&:product).each do |product|
        setting[product] = true
      end

      memo
    end
  end

  # This will take a complex hash containing
  # configuration for each product type (i.e. perks, select, managed_services)
  # and make sure the product config state for each is properly stored in the database
  def product_type_config= config_hash
    @product_type_config = nil

    products.delete_all

    config_hash.each do |setting|
      product_type,settings = setting

      record = product_types.find_by_product_type(product_type)
      record.update_attribute(:status, settings.delete("status"))

      # removes any vendor products record, just so that
      # any values that are unchecked don't show up
      # in the vendor_products table.

      # for every product that was selected, we will create
      # a vendor_products record
      settings.keys.each do |product|
        products.create(product: product,product_type:product_type)
      end
    end
  end

  # creates status tracking records for each vendor product type
  def create_product_type_records
    ProductType.available_values.each do |product_type|
      unless product_types.where(product_type:product_type).count > 0
        product_types.create(product_type: product_type, status: "inactive")
      end
    end
  end

  def create_all_item_menu_templates

    mt = MenuTemplate.create!(
      :name => "A La Carte", :pricing_type => MenuPricingType.item_level, 
      :start_date => Date.today, :vendor_id => self.id, :product_type => ProductType.managed_services, 
      :cogs => 0, :sell_price => 0, :retail_price => 0, :all_items => true)

    menu_templates.push(mt)
  end

  def inventory_item_updated inventory_item
    menu_templates.each do |mt|
      mt.inventory_item_updated(inventory_item)
    end
  end

  def initial_values
    self.default_tax_rate ||= 0
    self.address ||= Address.new if self.new_record?
  end

  def billing_address
    result = ""
    return result if address.nil?

    result << "#{address.address1}<br>" unless address.address1.empty? 
    result << "#{address.address2}<br>" unless address.address2.empty?
    result << "#{address.city}, " unless address.city.empty?
    result << "#{address.state} " unless address.state.empty?
    result << "#{address.zip_code}" unless address.zip_code.empty?

    result.html_safe
  end

  def menu_templates_by_product product
    menu_templates.select{|mt| mt.product_type == Product.find_parent(product) && (mt.start_date.nil? ? DateTime.parse('0001-01-01') : mt.start_date) <= DateTime.now && (mt.expiration_date.nil? ? DateTime.parse('9999-01-01') : mt.expiration_date) >= DateTime.now} 
  end

  def inventory_items_by_product_type product_type
     inventory_items.select{|i| i.inventory_item_product_types.where(:product_type => product_type).count > 0}
  end

  def self.vendors_by_product product
    @vendors = Vendor.find_by_sql("SELECT DISTINCT vendors.* FROM vendors INNER JOIN vendor_products ON vendor_products.vendor_id = vendors.id INNER JOIN vendor_product_types ON vendor_product_types.vendor_id = vendors.id WHERE vendor_products.product = '" + product + "' AND vendor_product_types.product_type = '" + Product.find_parent(product) + "' AND vendor_product_types.status = 'active' ORDER BY vendors.name")
  end

end
