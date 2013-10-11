class EventsController < ApplicationController
  # load_and_authorize_resource
  before_filter :authenticate_user!

  respond_to :html, :js

  def index
    options = {:artificial_attributes => {"vendor"=>"vendors.name","account"=>"accounts.name", "event_time" => "event_start_time", "date" => "event_start_time"}}
    respond_to do |format|
      format.html do
        if params[:xls]
          redirect_to :action => "index", :format => "xls", :searchable => params[:searchable], :direction => params[:direction], :sort => params[:sort]
        else
          @events = Kaminari.paginate_array(Event.includes(:account).includes(:vendors).search_sort_paginate(params, options)).page(params[:page])
        end
      end
      format.xls do
        @events = Event.joins(:account).search_sort_paginate(params, options)
        headers["Content-Disposition"] = "attachment; filename=\"my_events.xls\""
      end
    end
  end

  def show
    @event = Event.find(params[:id])
    @documents = @event.documents.all

    respond_to do |format|
      format.html
    end
  end

  def new
      @event = Event.new
      @products = Product.available_values
  end

  def edit
    respond_with @event = Event.find(params[:id])
  end

  def create

    # Fetch the current user
    params[:event][:created_by_id] = current_user.id unless current_user.nil?

    # Wrap in transaction, menu can get orphaned if event fails
    @event = Event.new(permitted_params.event)

    if @event.save
      flash[:notice] = "Event created successfully."
      redirect_to @event
    else
      flash[:error] = "Error creating event - " + @event.errors.full_messages.join(", ")
      redirect_to events_url
    end
  end

  def update
    @event = Event.find(params[:id])

    if @event.update_attributes(permitted_params.event)
      flash[:notice] = "Event updated successfully."
      redirect_to @event
    else
      flash[:error] = "Error updating event - " + @event.errors.full_messages.join(", ")
      redirect_to @event
    end
  end

  def destroy
    @event = Event.find(params[:id])

    if @event.destroy
      flash[:notice] = "Event destroyed."
      redirect_to events_url
    else
      render action: "show"
    end
  end

  def destroy
    @event = Event.find(params[:id])
    begin
      @event.destroy
      flash[:notice] = "Event deleted."
      redirect_to events_url
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destorying event - " + e.to_s
      render action: "show"
    end
  end

  # -- Custom Methods -- #
  # This method grabs the party (party_id), party_type (account/vendor)
  # that is being passed up from the view layer, and then delegates the
  # objects @party and @event to the model method.
  def generate
    @event = Event.find(params[:id])
    %w{action controller}.each {|key| params.delete(key)}
    params[:current_user] = current_user.id
    document = @event.generate_document(params)

    document ? flash[:notice] = "#{params[:doc_type].titleize} being generated. Please refresh the page in a few seconds and then check the document table." : flash[:alert] = "Failed to generate #{params[:doc_type].titleize}."
    redirect_to event_path(selected: 'financials')
  end

  # Reset the building and location site notes to the parent notes from the 
  # current location.
  def reload_site_notes
    @event = Event.find(params[:id])
    @event.reload_site_notes
    @event.save

    flash[:notice] = "Reset Location and Building notes."
    redirect_to event_path(selected: 'notes')
  end

  def update_transaction_method
    @event = Event.find(params[:id])
    case params[:party_type]
      when "Account"
        @event.event_transaction_method.update_attributes!(:transaction_method => params[:transaction_method], :info1 => params[:info1], :info2 => params[:info2])
        respond_with(@event, @party = @event.account, @event_transaction_method = @event.event_transaction_method)
      when "Vendor"
        @event.event_vendors.where(:vendor_id => params[:party_id]).first.event_transaction_method.update_attributes!(:transaction_method => params[:transaction_method], :info1 => params[:info1], :info2 => params[:info2])
        respond_with(@event, @party = @event.event_vendors.where(:vendor_id => params[:party_id]).first.vendor, @event_transaction_method = @event.event_vendors.where(:vendor_id => params[:party_id]).first.event_transaction_method)
      else
        respond_with(@event)
      end
  end

  def duplicate_event
    if(params[:event_start_time] != '')
      @event_to_copy = Event.find(params[:id])
      @event = Event.find(params[:id]).dup

      @event.event_start_time = params[:event_start_time]
      if params[:event_end_time] != ''
        @event.event_end_time = params[:event_end_time]
      end
      if params[:setup_start_time] != ''
        @event.setup_start_time = params[:setup_start_time]
      end
      if params[:setup_end_time] != ''
        @event.setup_end_time = params[:setup_end_time]
      end
      if params[:quantity] != ''
        @event.quantity = params[:quantity]
      end
      if params[:meal_period] != ''
        @event.meal_period = params[:meal_period]
      end
      @event.name = params[:name]
      @event.status = Status::Event.scheduled
      @event.cancellation_reason = ""
      @event.canceled_within_24_hours = false
      @event.event_transaction_method = EventTransactionMethod.new

      @event_to_copy.event_vendors.each do |ev|
        # create new event_vendor on the existing event
        ev = ev.dup
        ev.event = @event
        ev.event_transaction_method = EventTransactionMethod.new
        ev.save
        @event.event_vendors.push ev
      end

      @event_to_copy.line_items.where(:parent_id => nil).each do |li|
        li = li.dup
        li.document_id = nil
        if li.line_item_sub_type == "Menu-Fee"
          li.quantity = @event.quantity
        end
        @event.line_items.push li
      end

      # Copy line items
      @event.save
      respond_with(@event)
    else
      respond_with(@error = "Event start date required")
    end
  end

end

