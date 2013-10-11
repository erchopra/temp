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

require "spec_helper"

describe Vendor do
  let(:vendor) { create(:vendor) }
  let(:vendor_product_type) { create(:vendor_product_type) }

  it "should have many line items" do
    vendor.should have_many(:line_items)
  end

  it "should be valid" do
    vendor.should be_valid
  end

  it "should automatically create inactive product type records" do
    vendor.product_types.inactive.count.should == 3
  end

  context "administering the product type settings" do
    let(:sample_request) do
      {
        "product_type_config" =>
          {
              "perks" => {"status" => "active", "popup" => "on"},
              "select"=>{"status"=>"active", "select"=>"on"},
              "managed_services"=>
                {
                  "status" => "active", "catering" => "on"
                }
          }
      }
    end

    it "should allow me to manage all product type settings" do
      vendor.product_type_config = sample_request["product_type_config"]
      vendor.product_types.active.count.should == 3
      vendor.has_product?("catering").should be_true
      vendor.has_product?("prepaid_popup_gold").should be_false
      vendor.has_product?("prepaid_popup_platinum").should be_false
    end

    it "should persist the settings and make them available in a convenient method" do
      config = vendor.product_type_config = sample_request["product_type_config"]
      config.keys.should_not be_empty
    end
  end
end
