# == Schema Information
#
# Table name: billing_references
#
#  id         :integer          not null, primary key
#  account_id :integer
#  name       :string(255)
#  event_id   :integer
#

class BillingReference < ActiveRecord::Base
  belongs_to :account
  belongs_to :event
  acts_as_taggable

  validates_presence_of :name
  # TODO Hugo Forte July 1 2013 - When I enable this, it disables saving tags for some reason - needs research
  # validate :unique_across_account

  # private
  #   def unique_across_account
  #     references = self.account.billing_references
  #     references.each do |reference| 
  #       if reference.name == self.name
  #         self.errors().add(:tags, message = 'name has to be unique for the account', options = {})
  #         break
  #       end
  #     end
  #   end

  def self.as_tag_list_with_name
    scoped.inject({}) do |memo,billing_reference|
      memo[billing_reference.name] = billing_reference.tag_list 
      memo
    end
  end

end
