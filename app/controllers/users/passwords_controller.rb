class Users::PasswordsController < Devise::PasswordsController
  
  def resource_params
    params.require(:user).permit(:login, :username, :email, :password, :password_confirmation, :role, :reset_password_token)
  end

  private :resource_params

end
