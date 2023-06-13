# frozen_string_literal: true

# two factor authentication
class TwoFactorAuthenticator
  def initialize(user)
    @user = user
  end

  def call
    @code = User.generate_otp(@user.otp_secret)
    CodeMailer.send_code(@code, @user.email).deliver_now
    # message = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']).messages.create(
    #   body: "your OTP is :: #{@code}",
    #   from: '+15856321481',
    #   to: '+923212674285'
    # )
    # puts message.sid
  end
end
