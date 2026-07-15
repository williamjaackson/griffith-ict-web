Rails.application.reloader.to_prepare do
  EventCatalog.reload!
  EventCatalog.all
end
