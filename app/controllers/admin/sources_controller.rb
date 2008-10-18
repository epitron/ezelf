class Admin::SourcesController < AdminController
  active_scaffold :sources do |config|
    config.columns = [:name, :description, :uri, :encoding]
    config.columns[:encoding].form_ui = :select
  end
end
