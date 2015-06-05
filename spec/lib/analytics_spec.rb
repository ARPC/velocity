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
  end          # makes sure this is not included in chart_data and that average_velocity uses it, but last_4_avg_velocity doesn't
                                                                                    # total from past weeks = 192
                                                                                    # total including current week = 199
  it 'calculates velocity by week' do
    velocities = Analytics.velocity
    expect(velocities[new_beginning_of_week(1.weeks.ago).strftime('%m/%d/%Y')]).to eq(5)
    expect(velocities[new_beginning_of_week(2.weeks.ago).strftime('%m/%d/%Y')]).to eq(74)
    expect(velocities[new_beginning_of_week(3.weeks.ago).strftime('%m/%d/%Y')]).to eq(93)

  end

  it 'limits to only those from a specific date' do
    velocities = Analytics.velocity(:from => 2.weeks.ago.beginning_of_week)
    expect(velocities[new_beginning_of_week(1.weeks.ago).strftime('%m/%d/%Y')]).to eq(5)
    expect(velocities[new_beginning_of_week(2.weeks.ago).strftime('%m/%d/%Y')]).to eq(74)
  end

  describe '#get_velocity_information' do

    it 'provides the current velocity' do
      current_velocity = Analytics.current_velocity
      expect(current_velocity).to eq(7)
    end

    it 'provides the average of the previous four weeks and doesn\'t start starts with the earlier weeks if week four doesn\'t exist' do
      last_4_avg_velocity = Analytics.last_4_avg_velocity
      expect(last_4_avg_velocity).to eq(43) # 172 from past four weeks / 4 weeks of data
    end                                     # should not include most current week

    it 'provides the average of all the velocities' do
      avg_velocity = Analytics.avg_velocity
      expect(avg_velocity).to eq (12.8) # 192 from past weeks / 15 weeks of data
    end                                 # should not include most recent week

    it 'makes sure the chart data does not include the current week and should handle empty data after a date' do
      chart_data = Analytics.chart_data
      latest_week_value = latest_week_value(chart_data)
      expect(latest_week_value).to_not eq(7)
      # most recent velocity on chart (5) should not be equal to current velocity (7)
    end

    it 'makes sure that the last chart data point is the velocity from last week and should handle empty data after a date' do
      chart_data = Analytics.chart_data
      latest_week_value = latest_week_value(chart_data)
      expect(latest_week_value).to eq(5)
    end

    describe 'start of sprint is Thursday 1:00PM' do
      it 'the current velocity should not include the value from last thursday before 1:00PM' do
        last_thursday_before_one = (new_beginning_of_week(Time.now) - 1).to_datetime
        TaskMetric.create!(:leankit_id => 8, :estimate => 1, :done_at => last_thursday_before_one)
        current_velocity = Analytics.current_velocity
        expect(current_velocity).to eq(7)
      end

      it 'the current velocity should include the value from last thursday after 1:00PM' do
        last_thursday_after_one = (new_beginning_of_week(Time.now) + 1).to_datetime
        TaskMetric.create!(:leankit_id => 9, :estimate => 2, :done_at => last_thursday_after_one)
        current_velocity = Analytics.current_velocity
        expect(current_velocity).to eq(9)
      end
    end

    # describe 'Remaining Time' do
    #   it 'gets the correct time in seconds until the sprint ends' do
    #     time_remaining = Analytics.time_remaining
    #     end_of_sprint = Time.now.beginning_of_week + 7*24*60*60 + 13*60*60
    #     now = Time.now
    #     expect(time_remaining).to eq((end_of_sprint - now).round(0))
    #   end
    #
    #   it 'gets the correct time in words until the sprint ends' do
    #     time_remaining
    #     time_remaining_in_words = Analytics.time_remaining_in_words
    #     puts time_remaining_in_words
    #     expect (time_remaining_in_words).to
    #   end
    #
    # end

    def latest_week_value(chartdata)
      chartdata.to_a[-1][1]
    end
  end
  def new_beginning_of_week(time)
    if [:thursday?].any? { |day| Date.today.send(day) } && Time.now.hour<13
      return time.beginning_of_week - 7*24*60*60 + 13*60*60
    else
      return time.beginning_of_week + 13*60*60 #Thursday at 1:00PM
    end
  end
end
