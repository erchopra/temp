# Report on the catering sales made today

module CateringSchedulePreview
  @queue = :email_reports
  def self.perform(user_name, user_email, method)
    events = Event.catering_schedule_preview
    Email.catering_schedule_preview.each do |email|
      CateringReportMailer.catering_schedule_preview(email, events, user_name, user_email, method).deliver
      Rails.logger.info "Sent Fooda catering schedule preview email report to #{email.email}"
    end
  end
end