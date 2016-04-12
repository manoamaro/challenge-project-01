class SaveQuery
  include Sidekiq::Worker
  sidekiq_options queue: 'priority', retry: false

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
