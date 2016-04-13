workers Integer(ENV['WEB_CONCURRENCY'] || 1)
threads_count = Integer(ENV['MAX_THREADS'] || 16)
threads 1, threads_count

preload_app!
rackup DefaultRackup
rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

if rails_env == "production"
  app_dir = '.'
  tmp_dir = "#{app_dir}/tmp"

  stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

  port ENV['PORT'] || 3000

  pidfile "#{tmp_dir}/pids/puma.pid"
  state_path "#{tmp_dir}/pids/puma.state"
else
  port ENV['PORT'] || 3000
end

activate_control_app

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
