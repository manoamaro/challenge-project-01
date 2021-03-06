class HomeController < ApplicationController

  def index
  end

  ##
  # Method to perform the search.
  # It also saves the query into Redis and creates a scheduled Job
  # to consume this query. If the user keeps typing, the query is updated
  # and the date too, so the scheduled job will only run after 3 sec since
  # the last time the user typed something.
  ##
  def search
    send_to_analytics session.id, params[:q]
    render nothing: true
  end


  def analytics
    render json: $redis.hgetall('analytics')
  end

  def destroy_analytics
    $redis.del "analytics"
    render nothing: true
  end


  private
  def send_to_analytics(session_id, query)
    $redis.set "#{session.id}.query", query
    $redis.set "#{session.id}.last_update", Time.now.to_i
    if !$redis.exists("#{session.id}.job")
      job_id = SaveQuery.perform_in 3.seconds.from_now, session_id
      $redis.set "#{session.id}.job", job_id
    end
  end

end
