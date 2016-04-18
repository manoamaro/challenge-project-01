require 'rails_helper'

RSpec.describe 'SaveQueryWorker', type: :request do

  before(:all) do
    $redis = MockRedis.new
  end

  describe "when receives a query" do
    it "should create a new job" do
      expect {
        get '/search'
      }.to change(SaveQuery.jobs, :size).by(1)
    end
  end


end
