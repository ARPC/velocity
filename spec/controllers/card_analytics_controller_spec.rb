require 'rails_helper'

RSpec.describe CardAnalyticsController, :type => :controller do

  describe "GET velocity" do
    it "returns http success" do
      get :velocity
      expect(response).to be_success
    end
  end

  describe "GET extract" do
    it "returns http success" do
      get :extract
      expect(response).to be_success
    end
  end

end
