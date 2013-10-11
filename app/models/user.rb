# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :string(255)
#  username               :string(40)
#

class User < ActiveRecord::Base
  
  devise :database_authenticatable, 
    # :registerable, 
    :confirmable,
    :recoverable, :rememberable, :trackable, :validatable,
    :authentication_keys => [:username]

  has_one :profile
  has_many :documents, :foreign_key => 'creator_id'
  has_many :assigned_issues, foreign_key: 'assignee_id', class_name: 'Issue'
  has_many :reported_issues, foreign_key: 'assigner_id', class_name: 'Issue'
  has_many :comments

  def to_s
    username
  end

  [["opened", false],["closed", true]].each do |meth|
    define_method("#{meth[0]}_assigned_issues") do
      assigned_issues.select {|i| i.status == meth[1]}
    end
  end

  [["opened", false],["closed", true]].each do |meth|
    define_method("#{meth[0]}_reported_issues") do
      reported_issues.select {|i| i.status == meth[1]}
    end
  end

  protected
    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      login = conditions.delete(:username)
      where(conditions).where(["lower(username) = :value", { :value => login.downcase }]).first
    end


    # # after_email_confirmation callback
    # def confirm!
    #   super
    #   set_role_to_admin_for_devs
    # end

    # # will be removed after roles are decided
    # def set_role_to_admin_for_devs
    #   self.role = 'admin'
    #   self.save!
    # end

end