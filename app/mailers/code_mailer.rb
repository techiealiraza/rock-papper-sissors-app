class CodeMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.code_mailer.send_code.subject
  #
  def send_code(user)
    @code = User.generate_otp(user.otp_secret)

    mail to: 'to@example.org'
  end
end
