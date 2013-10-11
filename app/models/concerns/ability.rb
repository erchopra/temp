class Ability
  include CanCan::Ability

  def initialize(user)

    # Guest user
    user ||= User.new

    # User role abilities
    can :manage, :all if user.role == 'admin'
    can :manage, :all if user.role == 'ops'
    can :manage, :all if user.role == 'sales'

  end
end
