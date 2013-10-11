module EventsHelper
  
  def account_select
    Account.all.map { |account| [account.name, account.id]}
  end

  def vendor_select
    Vendor.all.map { |vendor| [vendor.name, vendor.id]}
  end

  def menu_select
    MenuTemplate.all.map { |menu| [menu.name, menu.id]}
  end
end