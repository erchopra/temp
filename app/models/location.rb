# == Schema Information
#
# Table name: locations
#
#  id                          :integer          not null, primary key
#  name                        :string(255)
#  location_type               :string(255)
#  expected_participation      :integer
#  privacy                     :string(255)
#  service_event_instructions  :text
#  connectivity_instructions   :text
#  delivery_event_instructions :text
#  building_address_notes      :string(255)
#  contact_id                  :integer
#  account_id                  :integer
#  building_id                 :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#

class Location < ActiveRecord::Base
  belongs_to :account
  belongs_to :building
  belongs_to :contact

  has_many :events, :dependent => :restrict

  validates_presence_of :account_id
  validates_presence_of :building_id

  after_initialize :initial_values

  def spot?
    self.location_type == LocationType.spot
  end

  def delivery?
    self.location_type == LocationType.delivery
  end

  def html_address
    address = ""
    return address if building.address.nil?

    address << "#{building.address.address1}<br>" unless building.address.address1.empty? 
    address << "#{building_address_notes}<br>" unless building_address_notes.empty?
    address << "#{building.address.city}, " unless building.address.city.empty?
    address << "#{building.address.state} " unless building.address.state.empty?
    address << "#{building.address.zip_code}" unless building.address.zip_code.empty?

    address.html_safe
  end

  private

    def initial_values
      self.expected_participation ||= 0
      self.service_event_instructions ||= ""
      self.connectivity_instructions ||= ""
      self.delivery_event_instructions ||= ""
      self.building_address_notes ||= ""
    end

end
