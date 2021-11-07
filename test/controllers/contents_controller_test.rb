require 'test_helper'

class ContentsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get contents_new_url
    assert_response :success
  end

  test "should get index" do
    get contents_index_url
    assert_response :success
  end

  test "should get show" do
    get contents_show_url
    assert_response :success
  end

  test "should get create" do
    get contents_create_url
    assert_response :success
  end

  test "should get destroy" do
    get contents_destroy_url
    assert_response :success
  end

end
