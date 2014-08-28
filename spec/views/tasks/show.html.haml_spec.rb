require 'rails_helper'

RSpec.describe "tasks/show", :type => :view do
  before(:each) do
    @task = assign(:task, Task.create!(
      :fog_bugz_id => 1,
      :title => "Title",
      :estimate => 2,
      :lane => "Lane",
      :status => "Status",
      :shepherd => "Shepherd",
      :board => "Board",
      :comments => "Comments"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Lane/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/Shepherd/)
    expect(rendered).to match(/Board/)
    expect(rendered).to match(/Comments/)
  end
end
