class HomeController < ApplicationController

  def index
  end

  def search
    render json: [{value: 1, display: 'TESTE'}]
  end
end
