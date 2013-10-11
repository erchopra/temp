# == Schema Information
#
# Table name: contacts
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  position              :string(255)
#  email                 :string(255)
#  phone_number          :string(255)
#  mobile_number         :string(255)
#  fax_number            :string(255)
#  primary_contact       :boolean
#  billing_notifications :boolean
#  event_notifications   :boolean
#  sms                   :boolean
#  account_id            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  vendor_id             :integer
#

class Contact < ActiveRecord::Base
  belongs_to :account
  belongs_to :vendor
  has_many :events, :dependent => :restrict

  validates :name, presence: true
  
  def to_s
    name
  end
end
