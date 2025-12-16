require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save user without username" do
    user = User.new(email: "test@example.com", password: "password123")
    assert_not user.save, "Saved user without username"
  end

  test "should not save user without email" do
    user = User.new(username: "testuser", password: "password123")
    assert_not user.save, "Saved user without email"
  end

  test "should not save user with duplicate username" do
    User.create!(username: "testuser", email: "test1@example.com", password: "password123")
    user = User.new(username: "testuser", email: "test2@example.com", password: "password123")
    assert_not user.save, "Saved user with duplicate username"
  end

  test "should save valid user" do
    user = User.new(username: "validuser", email: "valid@example.com", password: "password123")
    assert user.save, "Failed to save valid user"
  end
end
