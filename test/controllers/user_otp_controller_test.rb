# frozen_string_literal: true

require 'test_helper'

class UserOtpControllerTest < ActionDispatch::IntegrationTest
  test 'should get enable' do
    get user_otp_enable_url
    assert_response :success
  end

  test 'should get disable' do
    get user_otp_disable_url
    assert_response :success
  end
end
