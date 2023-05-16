# frozen_string_literal: true

class CodeMailer < ApplicationMailer
  def send_code(otpcode)
    @code = otpcode

    mail to: 'razaali15930@gmail.com', subject: 'OTP'
  end
end
