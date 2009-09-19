module StreamHelper
  def track_url(track)
    "#{url_for :only_path=>false, :action=>"track", :id=>track.id}.mp3"
  end
end
