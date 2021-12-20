require 'test_helper'

class Line::AuthenticationsControllerTest < ActionDispatch::IntegrationTest
  test "should get link" do
    get line_authentications_link_url
    assert_response :success
  end

  test "should get create" do
    get line_authentications_create_url
    assert_response :success
  end

end
