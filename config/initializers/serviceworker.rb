Rails.application.configure do
  config.serviceworker.routes do
    match "serviceworker.js"
  end
end
