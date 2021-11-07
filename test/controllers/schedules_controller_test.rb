require 'test_helper'

class SchedulesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get schedules_index_url
    assert_response :success
  end

  test "should get new" do
    get schedules_new_url
    assert_response :success
  end

  test "should get show" do
    get schedules_show_url
    assert_response :success
  end

  test "should get create" do
    get schedules_create_url
    assert_response :success
  end

  test "should get destroy" do
    get schedules_destroy_url
    assert_response :success
  end

end
