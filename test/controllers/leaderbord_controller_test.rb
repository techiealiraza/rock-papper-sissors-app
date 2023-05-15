require "test_helper"

class LeaderbordControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get leaderbord_index_url
    assert_response :success
  end
end
