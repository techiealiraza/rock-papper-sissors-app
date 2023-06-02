# frozen_string_literal: true

class CodeMailer < ApplicationMailer
  def send_code(otpcode, email)
    @code = otpcode

    mail to: email, subject: 'OTP'
  end
end
