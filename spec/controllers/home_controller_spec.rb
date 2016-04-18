require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe "GET #search" do
    it "returns http success" do
      get :search
      expect(response).to have_http_status(:success)
      response.body.should be_blank
    end
  end

end
