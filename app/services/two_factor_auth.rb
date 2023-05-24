class TwoFactorAuth
  def initialize(user)
    @user = user
  end

  def authenticate_2fa(otp_attempt, password)
    byebug
    if otp_attempt.present?
      auth_with_2fa(otp_attempt)
    elsif @user.valid_password?(password) && @user.otp_required_for_login
      byebug
      send_otp_code

    end
  end

  private

  def auth_with_2fa(otp_attempt)
    byebug
    return unless @user.validate_and_consume_otp!(otp_attempt)

    @user.save
  end

  def send_otp_code
    @code = User.generate_otp(@user.otp_secret)
    CodeMailer.send_code(@code, @user.email).deliver_now
    message = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']).messages.create(
      body: "your OTP is :: #{@code}",
      from: '+15856321481',
      to: '+923212674285'
    )
    puts message.sid
  end
end
