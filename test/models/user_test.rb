require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = build :user 
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'should have name' do
    @user.name = '     '
    assert_not @user.valid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email= 'a' * 251 + '@example.com'
    assert_not @user.valid?
  end

  test 'should have email' do
    @user.name = '   '
    assert_not @user.valid?
  end

  test 'should have unique email' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'email address should be saved as lower case' do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test 'should accept valid email format' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
      first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'should have password and password confirmation' do
    @user.password = @user.password_confirmation = nil
    assert_not @user.valid?
  end

  test 'should have a minimum password lenght' do
    @user.password = @user.password_confirmation = 'weak'
    assert_not @user.valid?
  end
end
