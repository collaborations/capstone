class ApplicationMailer < ActionMailer::Base
  default from: Settings.google_mail.email
  layout 'mailer'
end
