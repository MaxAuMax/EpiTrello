require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "project should have tasks association" do
    assert_respond_to Project.new, :tasks
  end

  test "project should have users association" do
    assert_respond_to Project.new, :users
  end

  test "project should belong to project_status" do
    assert_respond_to Project.new, :project_status
  end
end
