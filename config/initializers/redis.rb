$redis = Redis::Namespace.new("helpjuice-challenge", :redis => Redis.new(:host => 'redis'))
