class BillingReferencesController < ApplicationController

  respond_to :html

  def show
    respond_with(@reference = BillingReference.find(params[:id]), @entity = current_entity)
  end

  def edit
    @entity = current_entity
    @reference = billing_references.find(params[:id])
    if(current_event)
      @account_references = @event.account.billing_references.map(&:name)
      @account_reference_choices = @event.account.billing_references.as_tag_list_with_name
      render :create_update_for_event
    end
  end

  def new
    @reference = billing_references.build
    if(current_event)
      @account_references = @event.account.billing_references
      @account_reference_choices = @event.account.billing_references.as_tag_list_with_name
      render :create_update_for_event
    end
  end

  def create
    @reference = billing_references.create(permitted_params.billing_reference)

    if @reference.tags.count > 0
      if @reference.save
        flash[:notice] = "Billing reference created."
      else
        flash[:error] = "Error creating Billing reference - " + @reference.errors.full_messages.join(", ")
      end
    else
      @reference.destroy
      flash[:error] = "Error creating Billing reference - tags can't be blank"
    end
    redirect_to_current_entity
  end

  def update
    @reference = billing_references.find(params[:id])
    
    if @reference.update_attributes(permitted_params.billing_reference)
      flash[:notice] = "Billing reference updated."
      redirect_to_current_entity
    else
      flash[:error] = "Error updating Billing reference."
      redirect_to_current_entity
    end
  end

  def destroy
    @reference = billing_references.find(params[:id])
    begin
      @reference.destroy
      flash[:notice] = "Reference deleted."
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destorying reference - " + e.to_s
    end
    redirect_to_current_entity
  end

  def get_choices
    reference = BillingReference.find(params[:billing_reference_id])
    @list = reference.tag_list.map(&:name)
    respond_to do |format|
      format.json { render :json => @list }
    end
  end

  protected
    def redirect_to_current_entity
      if(current_account)
        redirect_to account_path(current_account, :selected => "billing")
      else
        redirect_to current_entity
      end
    end

    def current_entity
      if(current_account)
        @entity = current_account
      else 
        @entity = current_event
      end
    end

    def billing_references
      if(current_account)
        @reference = current_account.billing_references
      else 
        @reference = current_event.billing_references
      end
    end

    def current_account
      if (params[:account_id])
        @account ||= Account.find(params[:account_id])
      end
    end

    def current_event
      if (params[:event_id])
        @event ||= Event.find(params[:event_id])
      end
    end
end