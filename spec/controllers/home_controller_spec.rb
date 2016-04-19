require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  before(:all) do
    $redis = MockRedis.new
  end

  describe "GET #search" do
    it "returns http success" do
      get :search
      expect(response).to have_http_status(:success)
      expect(response.body).to be_blank
    end
  end

end
