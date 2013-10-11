class CateringReportMailer < ActionMailer::Base
  default from: "snappea-automation@fooda.com"

  def catering_schedule_preview(email, events, user_name, user_email, method)
    # Send an email
    @events = Event.catering_schedule_preview
    @user_name = "#{user_name} (#{user_email})"
    @method = method
    @preview_date = Date.tomorrow.strftime("%a, %b #{Date.tomorrow.day.ordinalize}, %Y")
    @status = [Status::Event.proposed, Status::Event.scheduled, Status::Event.active]

    mail(:to => email.email, :subject => "Fooda Report - Catering Schedule Preview")
  end

  def end_of_day_sales_report(email, events, user_name, user_email, method)
    # Send an email
    @events = Event.end_of_day_sales_report
    @user_name = "#{user_name} (#{user_email})"
    @method = method
    @preview_date = DateTime.now.strftime("%a, %b #{DateTime.now.day.ordinalize}, %Y")
    @status = [ "N/A" ]

    mail(:to => email.email, :subject => "Fooda Report - End of Day Sales")
  end

  def vendor_billing_summary(email, bcc_recipients, user_name, user_email, method, document_pdf, document_name, vendor_id)
    # Send an email
    @vendor = Vendor.find(vendor_id)
    @user_name = "#{user_name} (#{user_email})"
    @method = method
    attachments[document_name] = document_pdf

    if bcc_recipients && bcc_recipients.count > 0
      Rails.logger.info "Sent Vendor Billing Summary Email to " + email + " with BCC: " + bcc_recipients.join(", ")
      mail(:to => email, bcc: bcc_recipients, :subject => "Fooda - Vendor Billing Summary")
    else
      Rails.logger.info "Sent Vendor Billing Summary Email to " + email + " without BCC"
      mail(:to => email, :subject => "Fooda - Vendor Billing Summary")
    end
  end

end
