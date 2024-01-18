release: rails db:migrate
worker: bundle exec sidekiq -c 2 -C config/sidekiq.yml 
