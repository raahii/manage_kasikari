Rails.application.configure do
  config.serviceworker.routes do
    match "serviceworker.js"
    match "manifest.json"
  end
end
