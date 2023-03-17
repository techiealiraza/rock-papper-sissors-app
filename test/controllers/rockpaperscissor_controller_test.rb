require "test_helper"

class RockpaperscissorControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get rockpaperscissor_home_url
    assert_response :success
  end
end
