class Admin::DashboardController < ApplicationController
  
  respond_to :html

  def index
    respond_with( @markets = Market.all,
                  @pricing_tiers = PricingTier.all,
                  @buildings = Kaminari.paginate_array(Building.all).page(params[:page]),
                  @new_catering_sales = Email.where( :email_list => "new_catering_sales" ),
                  @catering_schedule_preview = Email.where( :email_list => "catering_schedule_preview" ),
                  @vendor_billing_summaries = Email.where( :email_list => "vendor_billing_summaries" )
      )
  end

end
