require 'test_helper'

class KasikarisControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get kasikaris_index_url
    assert_response :success
  end

  test "should get new" do
    get kasikaris_new_url
    assert_response :success
  end

  test "should get create" do
    get kasikaris_create_url
    assert_response :success
  end

  test "should get edit" do
    get kasikaris_edit_url
    assert_response :success
  end

  test "should get update" do
    get kasikaris_update_url
    assert_response :success
  end

  test "should get destroy" do
    get kasikaris_destroy_url
    assert_response :success
  end

end
