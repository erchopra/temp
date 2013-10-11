# == Schema Information
#
# Table name: inventory_items
#
#  id                 :integer          not null, primary key
#  name_vendor        :string(255)
#  description        :text
#  sku                :string(255)
#  featured           :boolean
#  type               :string(255)
#  image              :string(255)
#  vendor_id          :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  meal_type          :string(20)
#  cogs_cents         :integer
#  perks_price_cents  :integer
#  retail_price_cents :integer
#  name_public        :string(255)
#

class InventoryItem < ActiveRecord::Base
	belongs_to :vendor
  
  has_many :menu_template_inventory_items, :dependent => :restrict
  has_many :menu_templates, :through => :menu_template_inventory_items

  has_many :inventory_item_product_types, :dependent => :destroy

  default_scope order 'name_vendor'

  acts_as_taggable
  acts_as_taggable_on :external_tags
  acts_as_taggable_on :dietary_restrictions
  acts_as_taggable_on :options

  validates :cogs_cents, :numericality => true
  validates :perks_price_cents, :numericality => true
  validates :retail_price_cents, :numericality => true

  validates :name_vendor, :presence => true
  validates :name_public, :presence => true

  validates_presence_of :cogs_cents
  validates_presence_of :perks_price_cents
  validates_presence_of :retail_price_cents

  monetize :cogs_cents
  monetize :perks_price_cents
  monetize :retail_price_cents

  after_initialize :initial_values
  after_create :generate_sku
  after_update :alert_vendor_of_updated_inventory_item

  validates_inclusion_of :meal_type, :in => MealType.available_values

  public

    def product_types_allowed= hash
      inventory_item_product_types.clear
      hash.each do |product_type|
        inventory_item_product_types.push(InventoryItemProductType.new(:product_type => product_type.first))
      end
    end

  private

    def initial_values
      self.cogs_cents  ||= 0
      self.perks_price_cents  ||= 0
      self.retail_price_cents  ||= 0
      self.name_public ||= self.name_vendor
    end

    def generate_sku
      self.sku = "II-" + self.id.to_s.rjust(7, '0')
      self.save
    end

    def alert_vendor_of_updated_inventory_item
      vendor.inventory_item_updated(self)
    end

end
