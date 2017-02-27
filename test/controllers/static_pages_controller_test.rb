require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Manage-kasi-kari"
  end

  test "HomeページへのGETリクエスト" do
    get root_path
    assert_response :success
    assert_select "title", "Home | #{@base_title}"
  end

  test "HelpページへのGETリクエスト" do
    get help_path
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  test "AboutページへのGETリクエスト" do
    get about_path
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

  test "ContactページへのGETリクエスト" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end
end
