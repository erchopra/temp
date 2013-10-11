module Event::CateringFinancials

  def catering_total_billing
    revenue_total_by_party(account)
  end

  def catering_subtotal
    revenue_subtotal_by_party(account)
  end

  def catering_gratuity
    revenue_by_party_and_line_item_subtype(account, "Gratuity")
  end

  def catering_enterprise_fee
    revenue_by_party_and_line_item_subtype(account, "Enterprise Fee")
  end

  def catering_delivery_charge_to_vendor
    accum = Money.new(0)
    event_vendors.each do |ev|
      accum += revenue_by_party_and_line_item_subtype(ev.vendor, "Delivery Fee")
    end
    accum
  end

  def catering_total_tax
    revenue_general_tax_by_party(account) + revenue_by_party_and_line_item_subtype(account, "Tax")
  end

  def catering_revenue
    revenue_total_by_party(account) - revenue_general_tax_by_party(account) - revenue_by_party_and_line_item_subtype(account, "Tax")
  end

  def catering_cogs
    cogs = Money.new(0)
    event_vendors.each do |ev|
      cogs += (expense_total_by_party(ev.vendor) - expense_general_tax_by_party(ev.vendor) - expense_by_party_and_line_item_subtype(ev.vendor, "Tax"))
    end
    cogs
  end

  def catering_total_retail_base_price
    revenue_retail_subtotal_by_party(account)
  end

end
