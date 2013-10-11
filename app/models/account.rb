# == Schema Information
#
# Table name: accounts
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  website            :string(255)
#  account_type       :string(255)
#  active             :boolean
#  address_id         :integer
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  account_exec_id    :integer
#  sales_rep_id       :integer
#  account_manager_id :integer
#

class Account < ActiveRecord::Base
  include Fooda::Search
  include Fooda::Accounting
  include SearchSortPaginate

  global_site_search on: [:name, :"id::varchar(255)"]

  acts_as_payable
  acts_as_billable

  has_many :events, :dependent => :restrict
  has_many :account_pricing_tiers, :dependent => :destroy
  has_many :locations, :dependent => :destroy
  has_many :contacts, :dependent => :destroy
  has_many :billing_references, :dependent => :destroy
  has_many :preferences, :dependent => :destroy
  has_and_belongs_to_many :buildings
  has_many :issues, as: :subject
  belongs_to :address

  belongs_to :account_exec, :class_name => "User"
  belongs_to :sales_rep, :class_name => "User"
  belongs_to :account_manager, :class_name => "User"

  accepts_nested_attributes_for :address, allow_destroy: true
  accepts_nested_attributes_for :locations, allow_destroy: true

  validates_presence_of :name, :account_type
  validates_uniqueness_of :name

  default_scope order 'name'

  after_create :link_account_pricing_tiers
  after_initialize :initial_values

  has_attached_file :image,
    :storage => :fog,
    :default_url => '/images/default_account.png',
    :fog_credentials => {
      provider: "AWS",
      aws_access_key_id: AWS::Key,
      aws_secret_access_key: AWS::Secret,
      region: AWS::Region,
    },
     fog_public: true,
     fog_directory: AWS::PublicBucket,
     path: "account/:id.:extension"

  def to_search_result
    super.merge(:preview => "Account: " + self.pretty_id)
  end

  def as_json(options={})
    {:name            => self.name,
     :contacts        => self.contacts,
     :locations       => self.locations}
  end

  def self.all_possible_search_fields parent_model=nil
    [ { :name => :created_at, :as => :datetimerange } ]
  end

  def self.default_search_fields parent_model=nil
    [ { :name => :created_at, :as => :datetimerange } ]
  end

  def to_s
    name
  end

  def pretty_id
    "#{self.id.to_s.rjust(7, "0")}"
  end

  def link_account_pricing_tiers
    default_pricing_tier = PricingTier.where(:name => "Standard").first()
    Product.available_values.each do |product|
      unless AccountPricingTier.where(product: product, account_id: self.id).count > 0
        AccountPricingTier.create!(product: product, account_id: self.id, pricing_tier_id: default_pricing_tier.id)
      end
    end
  end

  def event_billing_reference group, choice=nil
    if choice.nil?
      BillingReference.where(event_id: self.events, name: group).flatten
    else
      BillingReference.where(event_id: self.events, name: group).tagged_with(choice).flatten
    end
  end

  def billing_reference_choices_by_group group
    self.billing_references.where(name: group).map {|m| m.tag_list}.flatten
  end

  def billing_reference_groups 
    self.billing_references.map {|br| br.name}.uniq
  end

  def html_address
    result = ""
    return result if address.nil?

    result << "#{address.address1}<br>" unless address.address1.empty? 
    result << "#{address.address2}<br>" unless address.address2.empty? 
    result << "#{address.city}, " unless address.city.empty?
    result << "#{address.state} " unless address.state.empty?
    result << "#{address.zip_code}" unless address.zip_code.empty?

    result.html_safe
  end


  private

    def initial_values
      self.address ||= Address.new  if self.new_record?
    end

end
