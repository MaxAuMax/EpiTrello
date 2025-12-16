require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "task should belong to project" do
    assert_respond_to Task.new, :project
  end

  test "task should belong to assignee" do
    assert_respond_to Task.new, :assignee
  end

  test "task should belong to task_status" do
    assert_respond_to Task.new, :task_status
  end
end
