class EventNotifier < ActionMailer::Base
  default from: "wits@library.nd.edu"


  def notify(text, primo_record = false)
    emails = 'jhartzle@nd.edu, lajamie@nd.edu, abales@nd.edu, rfox2@nd.edu, boze.1@nd.edu'
    @text = text
    @record_id = primo_record ? "http://onesearch.library.nd.edu/NDU:#{primo_record.id}" : 'no record id'

    mail(to: emails, subject: "Notification of primo data integrity issue: #{@record_id}")
  end


end
