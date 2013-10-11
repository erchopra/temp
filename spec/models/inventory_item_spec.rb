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

require "spec_helper"

describe InventoryItem do
  let(:inventory_item) { build(:inventory_item) }

  it "should be valid" do
    inventory_item.should be_valid
  end

  it "should require cogs" do
    build(:inventory_item, cogs: "").should_not be_valid
  end

  it "should require cogs that doesn't contain letters" do
    build(:inventory_item, cogs: "342ih2j342").should_not be_valid
  end

  it "should require a retail price" do
    build(:inventory_item, retail_price: "").should_not be_valid
  end

  it "should require a retail price that doesn't contain letters" do
    build(:inventory_item, retail_price: "342ih2j342").should_not be_valid
  end
end
