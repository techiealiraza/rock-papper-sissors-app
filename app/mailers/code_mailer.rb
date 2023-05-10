# frozen_string_literal: true

class CodeMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.code_mailer.send_code.subject
  #
  def send_code(otpcode)
    @code = otpcode

    mail to: 'razaali15930@gmail.com', subject: 'OTP'
  end
end
