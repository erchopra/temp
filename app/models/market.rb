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

class Market < ActiveRecord::Base
  validates :name, :presence => true
  has_many :buildings, :dependent => :restrict

  default_scope order('name ASC')

  validates_uniqueness_of :name
end
