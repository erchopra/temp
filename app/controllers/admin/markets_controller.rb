class Admin::MarketsController < ApplicationController

  def new
    @market = Market.new
  end

  def edit
    @market = Market.find(params[:id])
  end

  def update
    @market = Market.find(params[:id])
    if @market.update_attributes(permitted_params.market)
      flash[:notice] = "Market updated."
    else
      flash[:error] = "Error updating Market: " + @market.errors.full_messages.join(", ")
    end
    redirect_to admin_root_path(:selected => "markets")
  end

  def create
    @market = Market.new(permitted_params.market)

    if @market.save
      flash[:notice] = "Market Saved" 
    else
      flash[:error] = "Error creating Market: " + @market.errors.full_messages.join(", ")
    end
    redirect_to admin_root_path(:selected => "markets")
  end
  
  def destroy
    @market = Market.find(params[:id])
    begin
      @market.destroy
      flash[:notice] = "Market deleted."
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destorying Market: " + e.to_s
    end
    redirect_to admin_root_path(:selected => "markets")
  end

end
