schedule_file = Rails.root.join("config", "sidekiq_cron.yml")

Sidekiq::Cron::Job.load_from_hash(
  YAML.load_file(schedule_file)
)
