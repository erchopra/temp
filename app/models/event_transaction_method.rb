# == Schema Information
#
# Table name: event_transaction_methods
#
#  id                 :integer          not null, primary key
#  transaction_method :string(255)
#  info1              :string(255)
#  info2              :string(255)
#

class EventTransactionMethod < ActiveRecord::Base
end
