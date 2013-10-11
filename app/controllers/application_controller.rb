class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  
  # def after_sign_in_path_for resource
  #   "#{ root_url + 'profiles/' + @user.id.to_s }"
  # end

  # Denied permission delegation (from abilities model)
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = "Access Denied, Please sign in."
    redirect_to root_path
  end

  # ------ Private Methods ------ #
  private

    def permitted_params
      @permitted_params ||= PermittedParams.new(params, current_user)
    end

    helper_method :permitted_params

    def flash_and_redirect(message, route)
      flash[:notice] = message
      redirect_to route
    end

    helper_method :flash_and_redirect
end
