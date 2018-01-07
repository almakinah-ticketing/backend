Rails.configuration.stripe = {
  :publishable_key => "pk_test_fm10TRh9MmJSObGmK461z326",
  :secret_key      => "sk_test_aEsg1AU5jvlkYlarXJNhC6iP"
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
