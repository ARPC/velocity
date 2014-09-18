require 'rails_helper'

RSpec.describe CardAnalyticsController, :type => :controller do

  describe "GET velocity" do
    it "returns http success" do
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
      get :download_extract
      expect(response).to be_success
    end
  end
end
