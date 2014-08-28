require 'rails_helper'

RSpec.describe "tasks/index", :type => :view do
  before(:each) do
    assign(:tasks, [
      Task.create!(
        :fog_bugz_id => 1,
        :title => "Title",
        :estimate => 2,
        :lane => "Lane",
        :status => "Status",
        :shepherd => "Shepherd",
        :board => "Board",
        :comments => "Comments"
      ),
      Task.create!(
        :fog_bugz_id => 1,
        :title => "Title",
        :estimate => 2,
        :lane => "Lane",
        :status => "Status",
        :shepherd => "Shepherd",
        :board => "Board",
        :comments => "Comments"
      )
    ])
  end

  it "renders a list of tasks" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Lane".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => "Shepherd".to_s, :count => 2
    assert_select "tr>td", :text => "Board".to_s, :count => 2
    assert_select "tr>td", :text => "Comments".to_s, :count => 2
  end
end
