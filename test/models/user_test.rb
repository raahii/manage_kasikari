# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  image           :string(255)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "インスタンスがvalidであること" do
    assert @user.valid?
  end
  
  test "nameが空白だとエラーとなること" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "emailが空白だとエラーとなること" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "nameが長すぎるとエラーとなること" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "emailが長すぎるとエラーとなること" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "メールアドレスっぴemailのバリデーションが通ること" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "emailがユニークであること" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "emailは大文字子小文字区別せずにユニークであること" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "パスワードが空白でないこと" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "パスワードが短すぎないこと" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
