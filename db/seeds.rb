require 'fooda/util'

Fooda::Util.shred_everything! unless Rails.env.production? or Rails.env.staging?

Fooda::Util.create_user_accounts_for "hugo", "jimmy", "mike", "david.bremner", "liliana.zektser"
Fooda::Util.create_pricing_tiers
Fooda::Util.create_line_item_types
Fooda::Util.create_ssp_persistences

address = Address.create!(:name => "Address Name", :address1 => "600 W. Chicago", :address2 => "Suite 750", :city => "Chicago", :state => "IL", :zip_code => "60654", :country => "United States")

a1 = Account.create!(:name => "Groupon", :website => "www.groupon.com", :active => true, :account_type => AccountType.corporate, :address_id => 1, sales_rep_id: 1+rand(User.all.count))
Account.create!(:name => "Echo", :website => "www.echo.com", :active => true, :account_type => AccountType.corporate, :address_id => 1, sales_rep_id: 1+rand(User.all.count))
Account.create!(:name => "Inner Workings", :website => "www.iwnk.com", :active => true, :account_type => AccountType.corporate, :address_id => 1, sales_rep_id: 1+rand(User.all.count))
Account.create!(:name => "Delliotte", :website => "www.deloitte.com", :active => true, :account_type => AccountType.residential, :address_id => 1, sales_rep_id: 1+rand(User.all.count))
Account.create!(:name => "Leo Burnett", :website => "www.leoburnett.us", :active => false, :account_type => AccountType.corporate, :address_id => 1, sales_rep_id: 1+rand(User.all.count))
Account.create!(:name => "Highground", :website => "www.highground.com", :active => true, :account_type => AccountType.corporate, :address_id => 1, sales_rep_id: 1+rand(User.all.count))

Market.create!(name: "Chicago")
Market.create!(name: "Chicago Suburbs")
Market.create!(name: "New York")

AccountPricingTier.create!(product: Product.select, :account_id => a1.id, :pricing_tier_id => 1)
AccountPricingTier.create!(product: Product.catering, :account_id => a1.id, :pricing_tier_id => 2)
AccountPricingTier.create!(product: Product.prepaid_popup_gold, :account_id => a1.id, :pricing_tier_id => 3)
AccountPricingTier.create!(product: Product.prepaid_popup_platinum, :account_id => a1.id, :pricing_tier_id => 3)

["Al's Beef", "Publican", "Zocolo", "Chick fil A", "Outdoor Grill"].each do |vendor_name|
  FactoryGirl.create :vendor, name: vendor_name
end

v1 = Vendor.find_by_name("Al's Beef")
v1.products.create!(product: "catering", product_type: "managed_services")
v1.product_types.each do |pt| pt.update_attributes(:status => 'active') end

v2 = Vendor.find_by_name("Publican")
v2.products.create!(product: "catering", product_type: "managed_services")
v2.product_types.each do |pt| pt.update_attributes(:status => 'active') end


# Vendor #1
# --------------------------------
i01_1 = InventoryItem.create!(:name_public => "Beef", :name_vendor => "Italian Beef", :description => "Al's Famous Italian Beef (It's why you're here!)", :cogs => 10.50, :perks_price => 14.10, :retail_price => 15.25, :vendor_id => v1.id, :meal_type => MealType.entrees)
i02_1 = InventoryItem.create!(:name_public => "Hot Dog", :name_vendor => "Chicago Style Hot Dog", :description => "An All Beef Hot Dog buried in a Steamed Poppy Seed Bun 'With Everything' includes: Mustard, Relish, Fresh Chopped Onions, Tomato, Kosher Pickle, Celery Salt & Sport Peppers", :cogs => 5.00, :perks_price => 7.10, :retail_price => 8.00, :vendor_id => v1.id, :meal_type => MealType.entrees)
i03_1 = InventoryItem.create!(:name_public => "Turkey Wrap", :name_vendor => "Southwest Turkey Wrap", :description => "Hickory-Smoked Turkey Breast, Smoky Bacon, Sharp Cheddar Cheese, Ripe Tomatoes, Shredded Lettuce, and our Zesty Chipotle Dressing wrapped in a Sun-Dried Tomato and Basil Tortilla ", :cogs => 3.00, :perks_price => 3.40, :retail_price => 3.50, :vendor_id => v1.id, :meal_type => MealType.entrees)

i04_1 = InventoryItem.create!(:name_public => "Chopped Salad", :name_vendor => "Al's 'Old Chicago' Chopped Salad", :description => "Chopped Fresh Greens, Diced Ripe Tomatoes, Carrots, Pasta, Gorgonzola Cheese, Chopped Bacon & Scallions with Diced Grilled Chicken Breast tossed in Al's House Balsamic Vinaigrette.", :cogs => 2.50, :perks_price => 3.10, :retail_price => 3.50, :vendor_id => v1.id, :meal_type => MealType.salads)
i05_1 = InventoryItem.create!(:name_public => "Caesar", :name_vendor => "The 'Big Boss' Caesar", :description => "Crisp Romaine Lettuce tossed in our Creamy Caesar Dressing with Croutons & Grated, Imported Parmesan Cheese. Try adding Diced Chicken or Sliced, Grilled Italian Sausage!", :cogs => 2.50, :perks_price => 3.20, :retail_price => 3.50, :vendor_id => v1.id, :meal_type => MealType.salads)
i06_1 = InventoryItem.create!(:name_public => "Garden Salad", :name_vendor => "Gourmet Garden Salad", :description => "Chopped Fresh Greens, Diced Tomatoes, Crisp Cucumbers, Carrots, Green Peppers Rings, Red Onions and Shredded Cheddar Cheese with your choice of Dressing", :cogs => 2.50, :perks_price => 3.20, :retail_price => 3.50, :vendor_id => v1.id, :meal_type => MealType.salads)

i07_1 = InventoryItem.create!(:name_public => "Fried Potatos", :name_vendor => "French Fried Potatos", :description => "Voted one of the 'Top 10 Best' in the U.S.A. BUT, don't take their word for it. Buy a few orders!", :cogs => 6.00, :perks_price => 7.10, :retail_price => 8.50, :vendor_id => v1.id, :meal_type => MealType.sides)
i08_1 = InventoryItem.create!(:name_public => "Chili", :name_vendor => "Bowl of Chili, No Beans!", :description => "With Cheddar Cheese & Onions", :cogs => 6.00, :perks_price => 7.10, :retail_price => 8.50, :vendor_id => v1.id, :meal_type => MealType.sides)
i09_1 = InventoryItem.create!(:name_public => "Soup", :name_vendor => "Soup of the Day", :description => "Our restaurant makes all of our soups fresh from scratch daily, available by the cup or bowl. Please ask your server about today's available soups.", :cogs => 6.00, :perks_price => 7.30, :retail_price => 8.50, :vendor_id => v1.id, :meal_type => MealType.sides)

i10_1 = InventoryItem.create!(:name_public => "Cheesecake", :name_vendor => "Chocolate Drenched Cheesecake", :description => "Plain or Chocolate Chip", :cogs => 6.00, :perks_price => 6.85, :retail_price => 8.50, :vendor_id => v1.id, :meal_type => MealType.desserts)
i11_1 = InventoryItem.create!(:name_public => "Italian Ice", :name_vendor => "Lezza Italian Ice", :description => "4oz. OR 16oz.", :cogs => 6.00, :perks_price => 7.50, :retail_price => 8.50, :vendor_id => v1.id, :meal_type => MealType.desserts)
i12_1 = InventoryItem.create!(:name_public => "Cookies", :name_vendor => "Otis Spunkmeyer Cookies", :description => "Made with the best ingredients out there, like real creamy butter, fresh whole eggs, premium Barry Callebaut Chocolate, plump California raisins, and so much more", :cogs => 6.00, :perks_price => 6.80, :retail_price => 8.50, :vendor_id => v1.id, :meal_type => MealType.desserts)

['Meat', 'Italian'].each do |tag|
  i01_1.tag_list.add(tag)
end
['Hot Peppers', 'Sweet Peppers'].each do |tag|
  i01_1.option_list.add(tag)
end
i01_1.save
['Meat', 'Local'].each do |tag|
  i02_1.tag_list.add(tag)
end
['Pickles', 'Celery Salt'].each do |tag|
  i02_1.tag_list.add(tag)
end
i02_1.save
['Meat', 'Bird'].each do |tag|
  i03_1.tag_list.add(tag)
end
i03_1.save
['Healthy', 'Vegetarian'].each do |tag|
  i04_1.tag_list.add(tag)
end
i04_1.save
['Healthy', 'Vegetarian'].each do |tag|
  i05_1.tag_list.add(tag)
end
i05_1.save
['Healthy', 'Vegetarian'].each do |tag|
  i06_1.tag_list.add(tag)
end
i06_1.save
['Signature', 'Vegan'].each do |tag|
  i07_1.tag_list.add(tag)
end
i07_1.save
['Spicy', 'Beanless'].each do |tag|
  i08_1.tag_list.add(tag)
end
i08_1.save
['Special'].each do |tag|
  i09_1.tag_list.add(tag)
end
i09_1.save
['Sweet', 'Unhealthy'].each do |tag|
  i10_1.tag_list.add(tag)
end
i10_1.save
['Sweet', 'Cold'].each do |tag|
  i11_1.tag_list.add(tag)
end
i11_1.save
['Sweet', 'Homemade'].each do |tag|
  i12_1.tag_list.add(tag)
end
i12_1.save

m1_1 = MenuTemplate.create!(:name => "Spring 1", :pricing_type => MenuPricingType.item_level, :expiration_date => "7/7/2015", :start_date => "4/4/2013", :vendor_id => v1.id, :product_type => ProductType.select, :cogs => 8, :sell_price => 9, :retail_price => 10)
m2_1 = MenuTemplate.create!(:name => "Spring 2", :pricing_type => MenuPricingType.menu_level, :expiration_date => "7/7/2015", :start_date => "4/4/2013", :vendor_id => v1.id, :product_type => ProductType.managed_services, :cogs => 8.25, :sell_price => 9.25, :retail_price => 11)
m3_1 = MenuTemplate.create!(:name => "Spring 3", :pricing_type => MenuPricingType.item_level, :expiration_date => "7/7/2015", :start_date => "4/4/2013", :vendor_id => v1.id, :product_type => ProductType.perks, :cogs => 8.25, :sell_price => 9.25, :retail_price => 12)

mtg1_1 = MenuTemplateGroup.create!(:choices_to_select => 3, :name => "Proteins")
mtg2_1 = MenuTemplateGroup.create!(:choices_to_select => 2, :name => "Breads")
mtg3_1 = MenuTemplateGroup.create!(:choices_to_select => 1, :name => "Salads")

m1_1.inventory_items << i01_1
m1_1.inventory_items << i02_1

m2_1.menu_template_groups << mtg1_1
m2_1.menu_template_groups << mtg2_1
m2_1.menu_template_groups << mtg3_1

m2_1.menu_template_inventory_items << MenuTemplateInventoryItem.create!(:inventory_item => i01_1, :menu_template_group => mtg1_1)
m2_1.menu_template_inventory_items << MenuTemplateInventoryItem.create!(:inventory_item => i02_1, :menu_template_group => mtg1_1)
m2_1.menu_template_inventory_items << MenuTemplateInventoryItem.create!(:inventory_item => i03_1, :menu_template_group => mtg1_1)
m2_1.menu_template_inventory_items << MenuTemplateInventoryItem.create!(:inventory_item => i04_1, :menu_template_group => mtg1_1)
m2_1.menu_template_inventory_items << MenuTemplateInventoryItem.create!(:inventory_item => i05_1, :menu_template_group => mtg2_1)
m2_1.menu_template_inventory_items << MenuTemplateInventoryItem.create!(:inventory_item => i06_1, :menu_template_group => mtg2_1)
m2_1.menu_template_inventory_items << MenuTemplateInventoryItem.create!(:inventory_item => i07_1, :menu_template_group => mtg2_1)
m2_1.menu_template_inventory_items << MenuTemplateInventoryItem.create!(:inventory_item => i08_1, :menu_template_group => mtg3_1)
m2_1.menu_template_inventory_items << MenuTemplateInventoryItem.create!(:inventory_item => i09_1, :menu_template_group => mtg3_1)
m2_1.menu_template_inventory_items << MenuTemplateInventoryItem.create!(:inventory_item => i10_1, :menu_template_group => mtg3_1)

m2_1.inventory_items << i11_1
m2_1.inventory_items << i12_1

m3_1.inventory_items << i01_1
m3_1.inventory_items << i02_1
m3_1.inventory_items << i03_1

mld1_1 = MenuLevelDiscount.create!(:min_participation => 50, :menu_template_id => 1, :cogs => 7, :sell_price => 8, :retail_price => 9)
mld2_1 = MenuLevelDiscount.create!(:min_participation => 80, :menu_template_id => 1, :cogs => 6.50, :sell_price => 7.50, :retail_price => 10)

m2_1.menu_level_discounts << mld1_1
m2_1.menu_level_discounts << mld2_1

v1.inventory_items.each do |i|
  ProductType.available_values.each do |pt|
    i.inventory_item_product_types << InventoryItemProductType.new(:product_type => pt)
  end
end

# Vendor #2
# --------------------------------
i01_2 = InventoryItem.create!(:name_public => "ham", :name_vendor => "benton country ham", :description => "sweet, smoky", :cogs => 10.50, :perks_price => 14.10, :retail_price => 15.25, :vendor_id => v2.id, :meal_type => MealType.entrees)
i02_2 = InventoryItem.create!(:name_public => "rossa", :name_vendor => "la quercia rossa", :description => "mild, smooth", :cogs => 5.00, :perks_price => 7.10, :retail_price => 8.00, :vendor_id => v2.id, :meal_type => MealType.entrees)
i03_2 = InventoryItem.create!(:name_public => "papparadelle", :name_vendor => "lamb papparadelle", :description => "fava beans, feta & mint", :cogs => 3.00, :perks_price => 3.40, :retail_price => 3.50, :vendor_id => v2.id, :meal_type => MealType.entrees)

i04_2 = InventoryItem.create!(:name_public => "turnips & parsnips", :name_vendor => "turnips & parsnips", :description => "lambic cherries & dukkah", :cogs => 2.50, :perks_price => 3.10, :retail_price => 3.50, :vendor_id => v2.id, :meal_type => MealType.salads)
i05_2 = InventoryItem.create!(:name_public => "trumpet mushrooms", :name_vendor => "marinated royal trumpet mushrooms", :description => "lentils & treviso", :cogs => 2.50, :perks_price => 3.20, :retail_price => 3.50, :vendor_id => v2.id, :meal_type => MealType.salads)
i06_2 = InventoryItem.create!(:name_public => "broccolini", :name_vendor => "broccolini", :description => "bagna cauda & fried shallots", :cogs => 2.50, :perks_price => 3.20, :retail_price => 3.50, :vendor_id => v2.id, :meal_type => MealType.salads)

i07_2 = InventoryItem.create!(:name_public => "pickles", :name_vendor => "daily pickles", :description => "pickles", :cogs => 6.00, :perks_price => 7.10, :retail_price => 8.50, :vendor_id => v2.id, :meal_type => MealType.sides)
i08_2 = InventoryItem.create!(:name_public => "frites", :name_vendor => "frites", :description => "with Barb's eggs", :cogs => 6.00, :perks_price => 7.10, :retail_price => 8.50, :vendor_id => v2.id, :meal_type => MealType.sides)
i09_2 = InventoryItem.create!(:name_public => "beets", :name_vendor => "beets", :description => "burrata, fennel, orange & chile", :cogs => 6.00, :perks_price => 7.30, :retail_price => 8.50, :vendor_id => v2.id, :meal_type => MealType.sides)

i10_2 = InventoryItem.create!(:name_public => "sorbets", :name_vendor => "seasonal sorbets", :description => "buttermilk sherbet, orange sherbet, apple cider sorbet & belgian waffle cookie", :cogs => 6.00, :perks_price => 6.85, :retail_price => 8.50, :vendor_id => v2.id, :meal_type => MealType.desserts)
i11_2 = InventoryItem.create!(:name_public => "waffle", :name_vendor => "waffle", :description => "raspberry jam & honey butter", :cogs => 6.00, :perks_price => 7.50, :retail_price => 8.50, :vendor_id => v2.id, :meal_type => MealType.desserts)
i12_2 = InventoryItem.create!(:name_public => "panna cotta", :name_vendor => "burnt honey panna cotta", :description => "graham cracker crumble, coriander flower, burnt lemon & frozen lemon curd", :cogs => 6.00, :perks_price => 6.80, :retail_price => 8.50, :vendor_id => v2.id, :meal_type => MealType.desserts)

['Meat', 'Italian'].each do |tag|
  i01_2.tag_list.add(tag)
end
['Hot Peppers', 'Sweet Peppers'].each do |tag|
  i01_2.option_list.add(tag)
end
i01_2.save
['Meat', 'Local'].each do |tag|
  i02_2.tag_list.add(tag)
end
['Pickles', 'Celery Salt'].each do |tag|
  i02_2.tag_list.add(tag)
end
i02_2.save
['Meat', 'Bird'].each do |tag|
  i03_2.tag_list.add(tag)
end
i03_2.save
['Healthy', 'Vegetarian'].each do |tag|
  i04_2.tag_list.add(tag)
end
i04_2.save
['Healthy', 'Vegetarian'].each do |tag|
  i05_2.tag_list.add(tag)
end
i05_2.save
['Healthy', 'Vegetarian'].each do |tag|
  i06_2.tag_list.add(tag)
end
i06_2.save
['Signature', 'Vegan'].each do |tag|
  i07_2.tag_list.add(tag)
end
i07_2.save
['Spicy', 'Beanless'].each do |tag|
  i08_2.tag_list.add(tag)
end
i08_2.save
['Special'].each do |tag|
  i09_2.tag_list.add(tag)
end
i09_2.save
['Sweet', 'Unhealthy'].each do |tag|
  i10_2.tag_list.add(tag)
end
i10_2.save
['Sweet', 'Cold'].each do |tag|
  i11_2.tag_list.add(tag)
end
i11_2.save
['Sweet', 'Homemade'].each do |tag|
  i12_2.tag_list.add(tag)
end
i12_2.save

m1_2 = MenuTemplate.create!(:name => "Summer 1", :pricing_type => MenuPricingType.item_level, :expiration_date => "7/7/2015", :start_date => "4/4/2013", :vendor_id => v2.id, :product_type => ProductType.select, :cogs => 18, :sell_price => 19, :retail_price => 21)
m2_2 = MenuTemplate.create!(:name => "Summer 2", :pricing_type => MenuPricingType.menu_level, :expiration_date => "7/7/2015", :start_date => "4/4/2013", :vendor_id => v2.id, :product_type => ProductType.managed_services, :cogs => 18.25, :sell_price => 19.25, :retail_price => 22)
m3_2 = MenuTemplate.create!(:name => "Summer 3", :pricing_type => MenuPricingType.item_level, :expiration_date => "7/7/2015", :start_date => "4/4/2013", :vendor_id => v2.id, :product_type => ProductType.perks, :cogs => 18.25, :sell_price => 19.25, :retail_price => 23)

m1_2.inventory_items << i01_2
m1_2.inventory_items << i02_2

m2_2.inventory_items << i01_2
m2_2.inventory_items << i02_2
m2_2.inventory_items << i03_2
m2_2.inventory_items << i04_2
m2_2.inventory_items << i05_2
m2_2.inventory_items << i06_2
m2_2.inventory_items << i07_2
m2_2.inventory_items << i08_2
m2_2.inventory_items << i09_2
m2_2.inventory_items << i10_2
m2_2.inventory_items << i11_2
m2_2.inventory_items << i12_2

m3_2.inventory_items << i01_2
m3_2.inventory_items << i02_2
m3_2.inventory_items << i03_2

mld1_2 = MenuLevelDiscount.create!(:min_participation => 50, :menu_template_id => 2, :cogs => 17, :sell_price => 18, :retail_price => 19)
mld2_2 = MenuLevelDiscount.create!(:min_participation => 80, :menu_template_id => 2, :cogs => 16.50, :sell_price => 17.50, :retail_price => 18)

m2_2.menu_level_discounts << mld1_2
m2_2.menu_level_discounts << mld2_2

v2.inventory_items.each do |i|
  ProductType.available_values.each do |pt|
    i.inventory_item_product_types << InventoryItemProductType.new(:product_type => pt)
  end
end

# Events
# --------------------------------

@event_contact = FactoryGirl.create(:contact)
@event_building = FactoryGirl.create(:building)
@event_location = FactoryGirl.create(:spot_location, :contact => @event_contact, :account => a1, :building => @event_building)

e1 = Event.create!(
  :account => a1, :name => "My Catering Event", :event_start_time => "5/1/2013 11:30pm", :quantity => 40,
  :meal_period => MealPeriod.lunch, :product => 'catering',
  setup_start_time: (Time.now + 4.hours), setup_end_time: (Time.now + 4.5.hours), status: Status::Event.scheduled,
  contact: @event_contact, location: @event_location)

e1.add_replace_menu_template(m2_1, 40, false)
e1.add_replace_menu_template(m2_2, 45, true)

e2 = Event.create!(
  :account => a1, :name => "My Popup Event", :event_start_time => "5/1/2013 11:30pm", :quantity => 70,
  :meal_period => MealPeriod.lunch, :product => 'popup',
  setup_start_time: (Time.now + 4.hours), setup_end_time: (Time.now + 4.5.hours), status: Status::Event.scheduled,
  contact: @event_contact, location: @event_location)


# Events for the email reports

8.times {
  FactoryGirl.create(:catering_event, event_start_time: DateTime.now + 1.day)
}

# Locations & Buildings
# --------------------------------

work = FactoryGirl.create( :building, :name => "600 West Chicago", :address => Address.first)
3.times {
  FactoryGirl.create( :building)
}

FactoryGirl.create(:contact, :account => Account.find_by_name("Delliotte"))
@mike = FactoryGirl.create(:contact, :name => "Mike Palac", :account => Account.find_by_name("Delliotte"))


FactoryGirl.create(:spot_location, :contact => @mike, :account => Account.find_by_name("Delliotte"), :building => work)
FactoryGirl.create(:spot_location, :contact => @mike, :account => Account.find_by_name("Delliotte"), :building => work)
FactoryGirl.create(:spot_location, :contact => @mike, :account => Account.find_by_name("Delliotte"), :building => work)

FactoryGirl.create(:delivery_location, :account => Account.find_by_name("Delliotte"), :building => work)
