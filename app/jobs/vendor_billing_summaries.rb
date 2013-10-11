module VendorBillingSummaries

  @queue = :email_reports

  def self.perform(user_name, user_email, method, date_integer, no_vendors)
    date = Time.at(date_integer).in_time_zone("US/Central").to_datetime

    Rails.logger.info "VendorBillingSummaries - Date: " + date.to_s + ", No Vendors: " + (!no_vendors.nil? && no_vendors).to_s

    Event.vendors_with_completed_events_in_past_24hours(date).each do |vendor_id, event_vendor_list|

      Rails.logger.info "VendorBillingSummaries - Processing Vendor ID: " + vendor_id.to_s + ", Number of events: " + event_vendor_list.count.to_s

      # Create the document
      doc_info = Document.create_vendor_billing_summary_document({"date"=>date, "event_vendor_list"=>event_vendor_list})

      # Fetch the vendor
      vendor = Vendor.find(vendor_id)

      if no_vendors
        email_recipients = Email.vendor_billing_summaries.map{|c| c.email}
        bcc_recipients = nil
      else
        email_recipients = vendor.contacts.where(:billing_notifications => true).map{|c| c.email}
        bcc_recipients = Email.vendor_billing_summaries.map{|c| c.email}
      end

      # Loop sending emails
      email_recipients.each do |email|
        CateringReportMailer.vendor_billing_summary(email, bcc_recipients, user_name, user_email, method, doc_info["document_pdf"], doc_info["document_name"], vendor_id).deliver
        Rails.logger.info "Sent Vendor Billing Summary for vendor ID " + vendor_id.to_s + " to " + email
      end

      unless no_vendors
        event_vendor_list.map{|ev| ev.vendor_billing_summary_sent_at = DateTime.now; ev.save}
      end

    end
  end
end
