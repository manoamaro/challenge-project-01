class SaveQuery
  include Sidekiq::Worker
  sidekiq_options queue: 'priority', retry: false

  ##
  # Job that will count the queries perfomed by users. It checks if
  # the last_update data is more than 3 seconds from now. If so, then
  # the user stopped typing for 3 sec, and the query is saved into Redis,
  # counting it. Else, the job is rescheduled to 3 sec from now.
  ##
  def perform(session_id)
    timestamp = $redis.get("#{session_id}.last_update").to_i
    if timestamp + 3.seconds < Time.now.to_i
      query = $redis.get "#{session_id}.query"
      $redis.hincrby "analytics", query.downcase, 1

      $redis.del "#{session_id}.job"
      $redis.del "#{session_id}.query"
    else
      self.class.perform_in 3.seconds.from_now, session_id
    end
  end

end
