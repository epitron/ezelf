module BrowseHelper
	def link_to_track(track)
		url = url_for :controller=>:stream, :action=>"track", :id=>track.id
		return "<a href=\"#{url}.mp3\">#{track.title || url}</a>"
	end
end
