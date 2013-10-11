# == Schema Information
#
# Table name: line_items
#
#  id                       :integer          not null, primary key
#  line_item_type           :string(255)
#  sku                      :string(255)
#  name                     :string(255)
#  notes                    :text
#  quantity                 :integer
#  include_price_in_expense :boolean
#  include_price_in_revenue :boolean
#  event_id                 :integer
#  inventory_item_id        :integer
#  billable_party_type      :string(255)
#  billable_party_id        :integer
#  payable_party_type       :string(255)
#  payable_party_id         :integer
#  tax_rate_expense         :decimal(, )
#  tax_rate_revenue         :decimal(, )
#  line_item_sub_type       :string(255)
#  after_subtotal           :boolean
#  percentage_of_subtotal   :boolean
#  document_id              :integer
#  unit_price_expense_cents :integer
#  unit_price_revenue_cents :integer
#  parent_id                :integer
#  menu_template_id         :integer
#

class LineItem < ActiveRecord::Base

  belongs_to :event
  belongs_to :document
  belongs_to :inventory_item
  belongs_to :menu_template

  validates_presence_of :event

  default_scope order 'line_item_type'
  default_scope order 'name'

  # See:
  # http://guides.rubyonrails.org/association_basics.html#polymorphic-associations
  # http://railscasts.com/episodes/154-polymorphic-association
  belongs_to :payable_party, :polymorphic => true
  belongs_to :billable_party, :polymorphic => true

  validates :unit_price_expense_cents, :numericality => true
  validates :unit_price_revenue_cents, :numericality => true

  validates_presence_of :unit_price_expense_cents
  validates_presence_of :unit_price_revenue_cents

  monetize :unit_price_expense_cents
  monetize :unit_price_revenue_cents

  after_initialize :initial_values

  public

    def pretty_id
      "#{self.id.to_s.rjust(7, "0")}"
    end

    def default_tax_rate
      case Product.find_parent(event.product)

        when ProductType.managed_services || ProductType.select
          if defined? event.location.building.market.default_tax_rate
            event.location.building.market.default_tax_rate
          else
            0
          end
        when ProductType.perks
          if defined? inventory_item.vendor.default_tax_rate
            inventory_item.vendor.default_tax_rate
          elsif defined? menu_template.vendor.default_tax_rate
            menu_template.vendor.default_tax_rate
          else
            0
          end
        else
          0
        end
    end

    def lock_tax_rate
      something_changed = false

      if self.payable_party && self.tax_rate_expense.nil?
        self.tax_rate_expense = self.default_tax_rate
        something_changed = true
      end

      if self.billable_party && self.tax_rate_revenue.nil?
        self.tax_rate_revenue = self.default_tax_rate
        something_changed = true
      end

      self.save if something_changed

    end
    
    # Financials helpers
    # ---------------------------------------------------------------------------
    def revenue_total
      include_price_in_revenue ? unit_price_revenue * quantity : Money.new(0)
    end

    def expense_total
      include_price_in_expense ? unit_price_expense * quantity : Money.new(0)
    end

    def revenue_tax_rate
      (tax_rate_revenue.nil? ? default_tax_rate : tax_rate_revenue)/100
    end

    def expense_tax_rate
      (tax_rate_expense.nil? ? default_tax_rate : tax_rate_expense)/100
    end

    def revenue_tax_unrounded
      revenue_total.dollars * revenue_tax_rate
    end

    def expense_tax_unrounded
      expense_total.dollars * expense_tax_rate
    end

    def revenue_tax
      revenue_total * revenue_tax_rate
    end

    def expense_tax
      expense_total * expense_tax_rate
    end

    def revenue_total_with_percentage subtotal
      subtotal * unit_price_revenue.to_s.to_f/100
    end

    def expense_total_with_percentage subtotal
      subtotal * unit_price_expense.to_s.to_f/100
    end

    # Filtering helpers
    # ---------------------------------------------------------------------------

    def per_person_price_for_vendor vendor
      (line_item_sub_type == "Menu-Fee") && ((!menu_template.nil? && menu_template.vendor_id == vendor.id) || (payable_party == vendor))
    end

    def menu_item_for_vendor vendor
       (line_item_sub_type == "Menu-Item") && ((!inventory_item.nil? && inventory_item.vendor_id == vendor.id) || (payable_party == vendor))
    end

    # This next case shouldn't happen, but we'll put something in for it just in case
    def menu_with_no_vendor
      (line_item_sub_type == "Menu-Fee" && menu_template.nil? && payable_party.nil?) || (line_item_sub_type == "Menu-Item" &&  inventory_item.nil? && payable_party.nil?)
    end

    def menu
      (line_item_sub_type == "Menu-Fee" || line_item_sub_type == "Menu-Item")
    end

    def associated_with_vendor
      menu && !menu_with_no_vendor
    end
    
    def pretty_quantity
      (self.quantity == 0)  ? "-" : self.quantity
    end

  private

    def initial_values
      self.quantity ||= 0
      self.after_subtotal  ||= false
      self.percentage_of_subtotal  ||= false
      self.unit_price_expense_cents  ||= 0
      self.unit_price_revenue_cents  ||= 0
      self.name ||= ""
      self.notes ||= ""
      self.quantity ||= 0
    end

end
