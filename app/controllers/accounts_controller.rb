class AccountsController < ApplicationController
  # load_and_authorize_resource

  respond_to :html, :json, :js

  def index
    respond_with(@accounts = Kaminari.paginate_array(Account.all).page(params[:page]))
  end

  def show
    respond_to do |format|

      format.html do
        if params[:xls] && !params[:meta_data].nil? && params[:meta_data] == "billing_references"
          redirect_to :action => "export_billing_references", :format => "xls", :searchable => params[:searchable], :direction => params[:direction], :sort => params[:sort]
        elsif params[:xls] && !params[:meta_data].nil? && params[:meta_data] == "events"
          redirect_to :action => "export_events", :format => "xls", :searchable => params[:searchable], :direction => params[:direction], :sort => params[:sort]
        else
          @account = Account.find(params[:id])
          @account_pricing_tiers = AccountPricingTier.find_all_by_account_id(params[:id])
          options = {:artificial_attributes => {"vendor"=>"vendors.name", "event_time" => "event_start_time", "date" => "event_start_time"}}
          @events = Kaminari.paginate_array(Event.includes(:account).includes(:vendors).where(:account_id => params[:id]).search_sort_paginate(params, options)).page(params[:page])

          if !params[:meta_data].nil? && params[:meta_data] == "events"
            redirect_to account_path(@account, :selected => "events", :searchable => params[:searchable], :direction => params[:direction], :sort => params[:sort])
          end
        end
      end

      format.json do
        respond_with(@account = Account.joins(:contacts).joins(:locations).find(params[:id]).to_json)
      end

    end
  end

  def export_events
    @account = Account.find(params[:id])
    
    respond_to do |format|
      format.xls do
        options = {:artificial_attributes => {"vendor"=>"vendors.name", "event_time" => "event_start_time", "date" => "event_start_time"}}
        @events = Event.joins(:account).includes(:vendors).where(:account_id => params[:id]).search_sort_paginate(params, options)
        headers["Content-Disposition"] = "attachment; filename=\"account_events.xls\""
      end
    end
  end

  def export_billing_references
    @account = Account.find(params[:id])
   
    respond_to do |format|
      format.xls do
        current_user = current_user
        headers["Content-Disposition"] = "attachment; filename=\"billing_reference_report.xls\""  
      end

    end
  end

  def edit
    @account = Account.find params[:id]
  end

  def new
    @account = Account.new
    @account.address = Address.new
  end

  def create
    @account = Account.new(permitted_params.account)

    if @account.save
      flash[:notice] = "Account created."
      redirect_to @account
    else
      flash[:error] = "Error creating account - " + @account.errors.full_messages.join(", ")
      redirect_to accounts_path
    end
  end

  def update
    @account = Account.find(params[:id])

    respond_to do |format|

      format.html do
        if @account.update_attributes(permitted_params.account)
          flash[:notice] = "Account updated successfully."
        else
          flash[:error] = "Error updating account - " + @account.errors.full_messages.join(", ")
        end
        redirect_to @account
      end

      format.js do
        if @account.update_attributes(permitted_params.account)
          head :ok
        else
          head :bad_request
        end
      end
    end
  end

  def destroy
    @account = Account.find(params[:id])
    begin
      @account.destroy
      flash[:notice] = "Account deleted."
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destorying account - " + e.to_s
    end
    redirect_to @account
  end

end
