# == Schema Information
#
# Table name: markets
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  default_tax_rate :decimal(, )      default(10.5), not null
#

require 'spec_helper'

describe Market do
  let (:market) { create(:market) }

  it "should be valid" do
    market.should be_valid
  end

  it "should require a name" do
    build(:market, name: nil).should_not be_valid
  end

  it "should require a non empty name" do
    build(:market, name: "").should_not be_valid
  end

end
