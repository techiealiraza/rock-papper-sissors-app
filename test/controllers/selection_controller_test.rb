require "test_helper"

class SelectionControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get selection_create_url
    assert_response :success
  end

  test "should get index" do
    get selection_index_url
    assert_response :success
  end
end
