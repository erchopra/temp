class Notifier < ActionMailer::Base
  default from: "snappea-automation@fooda.com"

  def send_issue_to_assignee(issue)
    # Send an email
    @issue = issue
    @assignee = issue.assignee
    @assigner = issue.assigner
    @subject = issue.subject

    mail(to: @assignee.email, subject: "[Fooda] You have been Assigned a New Issue")
  end
end
