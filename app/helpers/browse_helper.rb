module BrowseHelper
    def link_to_track(desc, track)
        url = url_for :controller=>:stream, :action=>"track", :id=>track.id
        return "<a href=\"#{url}.mp3\">#{desc || url}</a>"
    end
end
