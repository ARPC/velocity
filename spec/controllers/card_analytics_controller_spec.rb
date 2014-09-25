require 'kanban/report'
require 'rails_helper'

RSpec.describe CardAnalyticsController, :type => :controller do

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
      expect(Kanban::Report).to receive(:card_and_lane)
      get :download_extract
      expect(response).to be_success
    end
  end

  describe "GET download_missing_estimates" do
    it "returns http success" do
      expect(Kanban::Report).to receive(:cards_missing_size)
      get :download_missing_estimates
      expect(response).to be_success
    end
  end

  describe "GET download_missing_shepherds" do
    it "returns http success" do
      expect(Kanban::Report).to receive(:cards_missing_tags)
      get :download_missing_shepherds
      expect(response).to be_success
    end
  end

  describe "GET velocity_extract" do
    it "returns http success" do
      expect(Analytics).to receive(:velocity).and_return({ "09/18/2014" => 13, "09/25/2014" => 15 })
      get :download_velocity_extract
      expect(response).to be_success
      expect(response.filename).to eq('velocity_extract.csv')
    end
  end
end
