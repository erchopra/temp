class Admin::ManagedServicesReportsController < ApplicationController
  # load_and_authorize_resource
  respond_to :html, :js

  def index
    respond_to do |format|
      options = {:artificial_attributes => {"vendor"=>"vendors.name", "account"=>"accounts.name", "date" => "event_start_time", "sales_rep" => "accounts.sales_rep.username"}}
      format.html do
        if params[:xls]
          redirect_to :action => "index", :format => "xls", :searchable => params[:searchable], :direction => params[:direction], :sort => params[:sort]
        else
          @events, @levels = do_loops_events(Event.includes(:account).includes(:vendors).search_sort_paginate(params, options), params)
          @view_parameters = params
        end
      end

      format.xls do
        @view_parameters = params
        @events, @levels = do_loops_events(Event.includes(:account).includes(:vendors).search_sort_paginate(@view_parameters, options), @view_parameters)
        @current_user = current_user
        headers["Content-Disposition"] = "attachment; filename=\"managed_services.xls\""
      end
    end
  end

  def do_loops_events events, params
    levels = 0
    unless defined?(params[:searchable][:outer_group]).nil? || params[:searchable][:outer_group].empty?
      events = do_outer_loop events, params
      levels += 1
      unless defined?(params[:searchable][:inner_group]).nil? || params[:searchable][:inner_group].empty?
        events = do_inner_loop events, params
        levels += 1
      end
    end
    [events, levels]
  end

  def do_outer_loop events, params
    case params[:searchable][:outer_group]
      when "Sales Rep"
        events = events.group_by{|e| (e.account.sales_rep.nil? ? "" : e.account.sales_rep.username)}
      when "Date"
        events = events.group_by{|e| e.event_start_time.midnight}
      when "Account"
        events = events.group_by{|e| e.account.name}
      when "Vendor"
        events = events.group_by{|e| e.event_vendors.map { |v| v.vendor.name }.join(", ") unless e.event_vendors.nil?}
      else
        events = events
      end
  end

  def do_inner_loop events, params
    case params[:searchable][:inner_group]
      when "Sales Rep"
        events.each{ |k,v| events[k] = v.group_by{|e| (e.account.sales_rep.nil? ? "" : e.account.sales_rep.username)} }
      when "Date"
        events.each{ |k,v| events[k] = v.group_by{|e| e.event_start_time.midnight} }
      when "Account"
        events.each{ |k,v| events[k] = v.group_by{|e| e.account.name} }
      when "Vendor"
        events.each{ |k,v| events[k] = v.group_by{|e| e.event_vendors.map { |v| v.vendor.name }.join(", ") unless e.event_vendors.nil?}}
      end
      events
  end

end

