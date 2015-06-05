require 'rails_helper'

RSpec.describe "card_analytics/velocity.html.erb", :type => :view do
  it 'rounds velocities to two decimal places' do
    assign(:last_4_avg_velocity, 5.5555555555)
    assign(:avg_velocity, 6.66666666)

    render

    expect(rendered).to match(/5\.56/)
    expect(rendered).to match(/6\.67/)
  end
end
