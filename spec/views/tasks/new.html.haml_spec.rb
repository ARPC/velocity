require 'rails_helper'

RSpec.describe "tasks/new", :type => :view do
  before(:each) do
    assign(:task, Task.new(
      :fog_bugz_id => 1,
      :title => "MyString",
      :estimate => 1,
      :lane => "MyString",
      :status => "MyString",
      :shepherd => "MyString",
      :board => "MyString",
      :comments => "MyString"
    ))
  end

  it "renders new task form" do
    render

    assert_select "form[action=?][method=?]", tasks_path, "post" do

      assert_select "input#task_fog_bugz_id[name=?]", "task[fog_bugz_id]"

      assert_select "input#task_title[name=?]", "task[title]"

      assert_select "input#task_estimate[name=?]", "task[estimate]"

      assert_select "input#task_lane[name=?]", "task[lane]"

      assert_select "input#task_status[name=?]", "task[status]"

      assert_select "input#task_shepherd[name=?]", "task[shepherd]"

      assert_select "input#task_board[name=?]", "task[board]"

      assert_select "input#task_comments[name=?]", "task[comments]"
    end
  end
end
