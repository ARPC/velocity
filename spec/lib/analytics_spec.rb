require 'rails_helper'
require 'analytics'

RSpec.describe Analytics do
  before(:each) do
    TaskMetric.create!(:leankit_id => 1, :estimate => 2, :done_at => 1.weeks.ago)
    TaskMetric.create!(:leankit_id => 2, :estimate => 3, :done_at => 1.weeks.ago)

    TaskMetric.create!(:leankit_id => 3, :estimate => 52, :done_at => 2.weeks.ago)
    TaskMetric.create!(:leankit_id => 4, :estimate => 22, :done_at => 2.weeks.ago)

    TaskMetric.create!(:leankit_id => 5, :estimate => 67, :done_at => 3.weeks.ago)
    TaskMetric.create!(:leankit_id => 6, :estimate => 26, :done_at => 3.weeks.ago)
  end

  it 'calculates velocity by week' do
    velocities = Analytics.velocity
    expect(velocities[1.weeks.ago.beginning_of_week.strftime('%m/%d/%Y')]).to eq(5)
    expect(velocities[2.weeks.ago.beginning_of_week.strftime('%m/%d/%Y')]).to eq(74)
    expect(velocities[3.weeks.ago.beginning_of_week.strftime('%m/%d/%Y')]).to eq(93)
  end

  it 'limits to only those from a specific date' do
    velocities = Analytics.velocity(:from => 2.weeks.ago.beginning_of_week)
    expect(velocities[1.weeks.ago.beginning_of_week.strftime('%m/%d/%Y')]).to eq(5)
    expect(velocities[2.weeks.ago.beginning_of_week.strftime('%m/%d/%Y')]).to eq(74)
  end
end
