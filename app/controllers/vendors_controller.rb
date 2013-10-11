class VendorsController < ApplicationController
  # load_and_authorize_resource

  respond_to :html, :js, :json

  def index
    respond_with @vendors = Kaminari.paginate_array(Vendor.all).page(params[:page])
  end

  def show
    if params[:xls] && !params[:meta_data].nil? && params[:meta_data] == "events"
      redirect_to :action => "export_events", :format => "xls", :searchable => params[:searchable], :direction => params[:direction], :sort => params[:sort]
    else
      @vendor = Vendor.find(params[:id])
      options = {:artificial_attributes => {"vendor"=>"vendors.name", "account"=>"accounts.name", "event_time" => "event_start_time", "date" => "event_start_time"}}
      @events = Kaminari.paginate_array(Event.includes(:account).includes(:vendors).where(["vendors.id = " + params[:id]]).search_sort_paginate(params, options)).page(params[:page])
    
      if !params[:meta_data].nil? && params[:meta_data] == "events"
        redirect_to vendor_path(@vendor, :selected => "events", :searchable => params[:searchable], :direction => params[:direction], :sort => params[:sort])
      end
    end
  end

  def export_events
    @vendor = Vendor.find(params[:id])
    
    respond_to do |format|
      format.xls do
        options = {:artificial_attributes => {"vendor"=>"vendors.name", "account"=>"accounts.name", "event_time" => "event_start_time", "date" => "event_start_time"}}
        @events = Kaminari.paginate_array(Event.includes(:account).includes(:vendors).where(["vendors.id = " + params[:id]]).search_sort_paginate(params, options)).page(params[:page])
        headers["Content-Disposition"] = "attachment; filename=\"vendor_events.xls\""
      end
    end
  end

  def edit
    @vendor = Vendor.find params[:id]
  end

  def new
    @vendor = Vendor.new
    @vendor.address = Address.new
  end

  def create
    @vendor = Vendor.create(permitted_params.vendor)

    if @vendor.save
      flash[:notice] = "Vendor created successfully."
      redirect_to @vendor
    else
      flash[:error] = "Error creating vendor - " + @vendor.errors.full_messages.join(", ")
      redirect_to vendors_url
    end
  end

  def destroy
    @vendor = Vendor.find(params[:id])
    begin
      @vendor.destroy
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destorying Vendor - " + e.to_s
    end
    respond_with @vendor
  end

  def update
    @vendor = Vendor.find(params[:id])

    respond_to do |format|

      format.html do
        if @vendor.update_attributes(permitted_params.vendor)
          flash[:notice] = "Vendor updated successfully."
        else
          flash[:error] = "Error updating vendor - " + @vendor.errors.full_messages.join(", ")
        end
        if params[:vendor][:address_attributes]
          redirect_to vendor_path(@vendor, :selected => "billing_address")
        else
          redirect_to @vendor
        end
      end

      format.js do
        if @vendor.update_attributes(permitted_params.vendor)
          head :ok
        else
          head :bad_request
        end
      end
    end
  end

  def get_vendors_by_cuisine_and_product
    @vendors = Vendor.vendors_by_product(params[:product])
    
    if params[:cuisine] == "Any"
      respond_with(@vendors)
    else
      respond_with(@vendors.select{|v| v.cuisine_list.include?(params[:cuisine])})
    end
  end

  def get_vendor_menu_templates_by_product
    respond_with(Vendor.find(params[:id]).menu_templates_by_product(params[:product]))
  end
  
end
