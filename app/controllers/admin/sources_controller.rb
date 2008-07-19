class Admin::SourcesController < AdminController
  active_scaffold :sources do |config|
    config.columns.exclude :tracks
  end
end
