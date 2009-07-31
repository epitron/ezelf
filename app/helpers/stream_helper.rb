module StreamHelper
  def track_url(track)
    "#{url_for :action=>"track", :id=>track.id}.mp3"
  end
end
