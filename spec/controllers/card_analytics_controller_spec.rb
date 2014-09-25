require 'kanban/report'
require 'rails_helper'

RSpec.describe CardAnalyticsController, :type => :controller do
  let (:csv) { "Fog Bugz ID,Estimate,Title\n123,3,The Title 1\n234,5,The Title 2\n" }

  describe "GET velocity" do
    it "returns http success" do
      TaskMetric.create!(:estimate => 5, :fog_bugz_id => 123, :done_at => 1.weeks.ago)
      get :velocity
      expect(response).to be_success
    end
  end

  describe "GET report" do
    it "returns http success" do
      get :report
      expect(response).to be_success
    end
  end

  describe "GET download_extract" do
    it "returns http success" do
      expect(Kanban::Report).to receive(:card_and_lane).and_return(csv)
      get :download_extract
      expect(response).to be_success
      expect(response.content_type).to eq('application/csv')
      expect(response.body).to eq(csv)
    end
  end

  describe "GET download_missing_estimates" do
    it "returns http success" do
      expect(Kanban::Report).to receive(:cards_missing_size).and_return(csv)
      get :download_missing_estimates
      expect(response).to be_success
      expect(response.content_type).to eq('application/csv')
      expect(response.body).to eq(csv)
    end
  end

  describe "GET download_missing_shepherds" do
    it "returns http success" do
      expect(Kanban::Report).to receive(:cards_missing_tags).and_return(csv)
      get :download_missing_shepherds
      expect(response).to be_success
      expect(response.content_type).to eq('application/csv')
      expect(response.body).to eq(csv)
    end
  end

  describe "GET velocity_extract" do
    it "returns http success" do
      expect(Analytics).to receive(:velocity).and_return({ "09/18/2014" => 13, "09/25/2014" => 15 })
      get :download_velocity_extract
      expect(response).to be_success
      expect(response.content_type).to eq('application/csv')
      expect(response.body.split("\n")[0]).to eq('Week Of,Velocity')
      expect(response.body.split("\n")[1]).to eq('09/18/2014,13')
      expect(response.body.split("\n")[2]).to eq('09/25/2014,15')
    end
  end
end
