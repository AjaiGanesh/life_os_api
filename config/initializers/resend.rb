api_key = Rails.application.credentials.dig(:resend, :api_key)
raise "RESEND_API_KEY is missing" unless api_key
Resend.api_key = api_key
