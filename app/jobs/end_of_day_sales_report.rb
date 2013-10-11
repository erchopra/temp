# Preview of tomorrow's catering schedule

module EndOfDaySalesReport
  @queue = :email_reports
  def self.perform(user_name, user_email, method)
    events = Event.end_of_day_sales_report
    Email.end_of_day_sales_report.each do |email|
      CateringReportMailer.end_of_day_sales_report(email, events, user_name, user_email, method).deliver
      Rails.logger.info "Sent Fooda Sales end of day email report to #{email.email}"
    end
  end
end