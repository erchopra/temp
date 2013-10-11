class PricingTiersController < ApplicationController

  respond_to :html

  def index
    respond_with(@pricing_tiers = PricingTier.all)
  end

  def show
    respond_with(@pricing_tier = PricingTier.find(params[:id]))
  end

  def new
    respond_with(@pricing_tier = PricingTier.new)
  end

  def edit
    respond_with(@pricing_tier = PricingTier.find(params[:id]))
  end

  def create
    @pricing_tier = PricingTier.new(permitted_params.pricing_tier)

    if @pricing_tier.save
      flash[:notice] = "PricingTier was created successfully."
      redirect_to @pricing_tier
    else
      render action: "new"
    end
  end

  def update
    @pricing_tier = PricingTier.find(params[:id])


    if @pricing_tier.update_attributes!(permitted_params.pricing_tier)
      flash[:notice] = "PricingTier was updated successfully."
      redirect_to @pricing_tier
    else
      render action: "edit"
    end
  end

  def destroy
    @pricing_tier = PricingTier.find(params[:id])
    begin
      @pricing_tier.destroy
      flash[:notice] = "Pricing tier deleted."
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destorying pricing tier - " + e.to_s
    end
    redirect_to admin_root_path(:selected => "pricing_tiers")

  end

end
