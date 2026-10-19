api_key = Rails.application.credentials.dig(:resend, :api_key)

if api_key.present?
  Resend.api_key = api_key
elsif !Rails.env.test?
  raise "RESEND_API_KEY is missing"
end
