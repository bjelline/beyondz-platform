if Rails.env.production?

  ActionMailer::Base.smtp_settings = {
    :address => Rails.application.secrets.smtp_server,
    :port => 587,
    :domain => "beyondz.org",
    :authentication => :plain,
    :user_name => Rails.application.secrets.smtp_username,
    :password => Rails.application.secrets.smtp_password,
    :enable_starttls_auto => true
  }

else

  ActionMailer::Base.smtp_settings = {
    :address => Rails.application.secrets.smtp_server,
    :port => 587,
    :domain => "beyondz.com",
    :authentication => :plain,
    :user_name => Rails.application.secrets.smtp_username,
    :password => Rails.application.secrets.smtp_password,
    :enable_starttls_auto => true
  }

  # In a non-production environment, send all outgoing emails to a single email that can be used for
  # testing or other purposes, so real users don't receive test emails.
  class OverrideRecipientInterceptor
    def delivering_email(message)
      message.to = Rails.application.secrets.smtp_override_recipient
      message.cc = nil
      message.bcc = nil
    end
  end

  ActionMailer::Base.register_interceptor(OverrideRecipientInterceptor.new)

end
