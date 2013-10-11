module Roles
  extend ActiveSupport::Concerns

  ROLES = %w[admin ops sales]

  def role_symbols
    [role.to_sym]
  end

  def is_fooda_employee?
    return true unless User.where(:role => 'null')
  end

  def is_admin?
    @admin ||= User.where(:role => 'admin') ? true : false
  end

  def is_ops?
    @ops ||= User.where(:role => 'ops') ? true : false
  end

  def is_sales?
    @sales ||= User.where(:role => 'sales') ? true : false
  end

  # After being passed from this ROLES array into an area on front-end we then 
  # pass it back to User record adding it to a roles column.
  module ClassMethods
    def role?(role)
      return !!self.roles.find_by_name(role.to_s.camelize)
    end
  end
end
