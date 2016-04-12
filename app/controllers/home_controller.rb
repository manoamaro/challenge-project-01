require 'sidekiq/api'

class HomeController < ApplicationController

  def index
  end

  def search
    $redis.set "#{session.id}.query", params[:q]
    $redis.set "#{session.id}.last_update", Time.now.to_i
    if !$redis.exists("#{session.id}.job")
      job_id = SaveQuery.perform_in 3.seconds.from_now, session.id
      $redis.set "#{session.id}.job", job_id
    end
    render nothing: true
  end


  def analytics
    render json: $redis.hgetall('analytics')
  end

  def destroy_analytics
    $redis.del "analytics"
    render nothing: true
  end

end
