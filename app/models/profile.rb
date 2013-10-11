# == Schema Information
#
# Table name: profiles
#
#  id      :integer          not null, primary key
#  user_id :integer
#

class Profile < ActiveRecord::Base
  belongs_to :user
end
