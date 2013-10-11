class Admin::MailerController < ApplicationController
  # If params[:send] is true, queue a email job otherwise render the email html.
  
  def catering_schedule_preview
    if params[:send]
      Resque.enqueue(CateringSchedulePreview, current_user.username, current_user.email, "Force Send")
      flash_and_redirect "Sent Email: Catering Schedule Preview.", admin_root_path(:selected => "email_management")
    else
      # Generates a web preview
      @events = Event.catering_schedule_preview
      @user_name = current_user.nil? ? "Automated" : "#{current_user.username} (#{current_user.email})"
      @method = "Web Preview"
      @status = [Status::Event.proposed, Status::Event.scheduled, Status::Event.active]
      @preview_date = Date.tomorrow.strftime("%a, %b #{Date.tomorrow.day.ordinalize}, %Y")
      render :file => 'catering_report_mailer/catering_schedule_preview.html.haml', :layout => false
    end
  end

  def end_of_day_sales_report
    if params[:send]
      Resque.enqueue(EndOfDaySalesReport, current_user.username, current_user.email, "Force Send")
      flash_and_redirect "Sent Email: End of Day Sales Report.", admin_root_path(:selected => "email_management")
    else
      # Generates a web preview
      @events = Event.end_of_day_sales_report
      @user_name = current_user.nil? ? "None" : "#{current_user.username} (#{current_user.email})"
      @method = "Web Preview"
      @preview_date = DateTime.now.strftime("%a, %b #{DateTime.now.day.ordinalize}, %Y")
      @status = [ "N/A" ]

      render :file => 'catering_report_mailer/end_of_day_sales_report.html.haml', :layout => false
    end
  end

  def vendor_billing_summaries
    if params[:send]
      Resque.enqueue(VendorBillingSummaries, current_user.username, current_user.email, "Force Send", Time.now.to_i, params[:no_vendors])
      flash_and_redirect "Sent Email: Vendor Billing Summaries.", admin_root_path(:selected => "email_management")
    else
      # Generates a web preview of the email body
      @vendor = Vendor.first
      render :file => 'catering_report_mailer/vendor_billing_summary.html.haml', :layout => false
    end
  end

end