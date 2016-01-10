workers ENV.fetch('WEB_CONCURRENCY') { 1 }.to_i
threads_count = ENV.fetch('MAX_THREADS') { 1 }.to_i
threads threads_count, threads_count

preload_app!

rackup DefaultRackup
port ENV.fetch('PORT') { 3000 }
environment ENV.fetch('RACK_ENV') { 'development' }

before_fork do
  ActiveRecord::Base.establish_connection
end

on_worker_boot do
  ActiveRecord::Base.establish_connection
end
