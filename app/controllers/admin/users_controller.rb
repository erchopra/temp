class Admin::UsersController < ApplicationController

  respond_to :html

  def index
    respond_with(@users = User.all)
  end

  def edit
    respond_with(@user = User.find(params[:id]))
  end

  def update
    @user = User.find(params[:id])

    @user.update_attributes(permitted_params.user)
    if @user.update_attributes
      flash_and_redirect(root_url, 'Updated user.')
    else
      flash_and_redirect(root_url, 'Error')
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    if @user.destroy
      flash[:notice] = "User deleted."
      redirect_to root_url
    else
      flash[:notice] = "Error deleting user."
      redirect_to root_url
    end
  end
end
