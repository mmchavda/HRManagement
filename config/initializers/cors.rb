Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' # Or set to specific domains, like 'http://localhost:3002'

    resource '*',
      headers: :any,
      methods: [:get, :post, :options]
  end
end