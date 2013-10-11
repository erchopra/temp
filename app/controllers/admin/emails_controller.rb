class Admin::EmailsController < ApplicationController

  def new
    @email = Email.new
  end

  def edit
    @email = Email.find(params[:id])
  end

  def update
    @email = Email.find(params[:id])
    if @email.update_attributes(permitted_params.email)
      flash[:notice] = "Email updated."
      redirect_to admin_root_path(:selected => "email_management")
    else
      flash[:error] = "Error updating Email."
      redirect_to admin_root_path(:selected => "email_management")
    end
  end

  def create
    @email = Email.new(permitted_params.email)

    if @email.save
      flash_and_redirect("Email Saved", admin_root_path(:selected => "email_management"))
    else
      flash_and_redirect("Error creating Email: check for missing information", admin_root_path(:selected => "email_management"))
    end
  end

  def destroy
    @email = Email.find(params[:id])

    if @email.destroy
      flash_and_redirect("Email Deleted", admin_root_path(:selected => "email_management"))
    else
      flash_and_redirect("Error deleting Email", admin_root_path(:selected => "email_management"))
    end
  end

end
