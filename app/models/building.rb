# == Schema Information
#
# Table name: buildings
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  insurance_required     :boolean
#  insurance_requirements :string(1000)
#  parking_information    :string(1000)
#  loading_information    :string(1000)
#  site_directions        :string(1000)
#  market_id              :integer
#  address_id             :integer
#  contact_title          :string(255)
#  contact_name           :string(255)
#  contact_phone          :string(255)
#  contact_cell           :string(255)
#  contact_fax            :string(255)
#  contact_email          :string(255)
#  timezone               :string(255)
#

class Building < ActiveRecord::Base
  include Fooda::Asset

  has_images

  belongs_to :market
  belongs_to :address
  accepts_nested_attributes_for :address, allow_destroy: true
  belongs_to :contact
  has_and_belongs_to_many :accounts
  has_many :locations, :dependent => :restrict

  after_initialize :initial_values

  validates :timezone, presence: true
  validates :market, presence: true

  default_scope order('name ASC')

  private
    def initial_values
      self.insurance_requirements ||= ""
      self.parking_information ||= ""
      self.loading_information ||= ""
      self.site_directions ||= ""
    end
end
