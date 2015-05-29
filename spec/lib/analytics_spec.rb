require 'rails_helper'
require 'analytics'

RSpec.describe Analytics do
  before(:each) do
    TaskMetric.create!(:leankit_id => 0, :estimate => 7, :done_at => 0.weeks.ago) # our current velocity = 7

    TaskMetric.create!(:leankit_id => 1, :estimate => 2, :done_at => 1.weeks.ago) # 5
    TaskMetric.create!(:leankit_id => 2, :estimate => 3, :done_at => 1.weeks.ago)

    TaskMetric.create!(:leankit_id => 3, :estimate => 52, :done_at => 2.weeks.ago) # 74
    TaskMetric.create!(:leankit_id => 4, :estimate => 22, :done_at => 2.weeks.ago)

    TaskMetric.create!(:leankit_id => 5, :estimate => 67, :done_at => 3.weeks.ago) # 93
    TaskMetric.create!(:leankit_id => 6, :estimate => 26, :done_at => 3.weeks.ago) # total from past four weeks = 172

    TaskMetric.create!(:leankit_id => 7, :estimate => 20, :done_at => 15.weeks.ago) # 20
  end                                                                               # total from past weeks = 192
                                                                                    # total including current week = 199
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

  describe '#get_velocity_information' do

    it 'provides the current velocity' do
      current_velocity = Analytics.get_velocity_information()[:current_velocity]
      expect(current_velocity).to eq(7)
    end

    it 'provides the average of the last four weeks' do
      last_4_avg_velocity = Analytics.last_4_avg_velocity
      expect(last_4_avg_velocity).to eq(43) # 172 from past four weeks / 4 weeks of data
    end                                     # should not include most current week

    it 'provides the average of all the velocities' do
      avg_velocity = Analytics.get_velocity_information[:avg_velocity]
      expect(avg_velocity).to eq (12.8) # 192 from past weeks / 15 weeks of data
    end                                 # should not include most recent week

    it 'provides the chart data which should not include the current week' do
      chart_data = Analytics.get_velocity_information[:chart_data]
      current_velocity = Analytics.get_velocity_information()[:current_velocity]
      expect(chart_data.to_a[-1][1]).to_not eq(current_velocity)
      # most recent velocity on chart (5) should not be equal to current velocity (7)
      # they might happen to be equal
      # assumes current velocity is correct
    end
  end
end
