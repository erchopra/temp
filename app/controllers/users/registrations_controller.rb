class Users::RegistrationsController < Devise::RegistrationsController

  def resource_params
    params.require(:user).permit(:login, :username, :email, :password, :password_confirmation, :role)
  end

  private :resource_params

end
