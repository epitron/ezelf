# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  ##############################################################################
  ## Link helpers
  ##############################################################################

  def track_url(track)
    "#{url_for :controller=>:stream, :action=>"track", :id=>track.id, :only_path=>false}.mp3"
  end

  def link_to_track(desc, track)
      %{<a href="#{ track_url(track) }">#{ desc || url }</a>}
  end

  def link_to_album(desc, album)
    url = url_for :controller=>:stream, :action=>"album", :id=>album.id
    %{<a href="#{url}.m3u">#{ desc || url }</a>}
  end

  def js(*args)
    content_for :header, javascript_include_tag(*args)
  end

  def css(*args)
    content_for :header, stylesheet_link_tag(*args)
  end
  
  ##############################################################################
  ## Random things
  ##############################################################################

  def get_random_albums(n=10)
    #result = begin
    #  self.find :all, :limit=>n, :order=>"RAND()", :include=>:artist
    #rescue ActiveRecord::StatementInvalid
    #  self.find :all, :limit=>n, :order=>"RANDOM()", :include=>:artist
    #end
    Album.all(:select=>:id).sort_by{rand}[0...n].map{|x|x.reload}
  end

  def random_elf
    elves = Dir["#{RAILS_ROOT}/public/elves/*"]
    filename = File.basename(elves[rand(elves.size)])
    url = "/elves/#{filename}"
    name = filename.gsub(/\.[^\.]+$/, '')

    OpenStruct.new(:url=>url, :name=>name)
  end




  ##############################################################################
  ## Tabs
  ##############################################################################

  class Tab
    attr_accessor :selected, :name, :parameters
      
    def initialize name, parameters
      @selected = false
      @name = name
      @parameters = parameters
    end
  end

    
  def main_tabs
    [
      Tab.new( "home",     { :controller => "home",   :action => "index"    }  ),
      Tab.new( "player",   { :controller => "browse", :action => "player"  }  ),
      Tab.new( "artists",  { :controller => "browse", :action => "artists"  }  ),
      Tab.new( "files",    { :controller => "browse", :action => "files"    }  ),
      Tab.new( "uploads",  { :controller => "browse",  :action => "uploads" }  ),
      Tab.new( "shuffle",  { :controller => "stream", :action => "shuffle.m3u"  }  ),
      #Tab.new( "stations", { :controller => "browse", :action => "stations" }  ),
    ]
  end


  def params_equal?(p1, p2)
    # insersect p1 and p2
    p1.stringify_keys!; p2.stringify_keys!
    (p1.keys & p2.keys).all? {|key| p1[key] == p2[key] }
  end


  def link_to_tab(tab, selected=false)
    link_to tab.name, tab.parameters
  end


  def tab_selected? tab
    params_equal? tab.parameters, request.parameters
  end


  def render_main_tabs
    output = []
    for tab in main_tabs
      link_to_tab tab
    end
  end


  def render_main_tabs_graphical
    tabs = main_tabs
      
    tabbar = [ image_tag("tabs/main_tabs_unselected_leftmost.gif") ]
    tabbar += tabs.zip( [image_tag("tabs/main_tabs_unselected_between.gif")] * tabs.length ).flatten
    tabbar[-1] = image_tag "tabs/main_tabs_unselected_rightmost.gif"
      
    tabbar.each_with_index do |element, i|
        
      if element.is_a? Tab
        tab       = element
        selected  = tab_selected? tab
        if selected
          case tab
            when tabs.first
              tabbar[i-1] = image_tag "tabs/main_tabs_selected_leftmost.gif"
              tabbar[i+1] = image_tag "tabs/main_tabs_selected_right.gif"
            when tabs.last
              tabbar[i-1] = image_tag "tabs/main_tabs_selected_left.gif"
              tabbar[i+1] = image_tag "tabs/main_tabs_selected_rightmost.gif"
            else
              tabbar[i-1] = image_tag "tabs/main_tabs_selected_left.gif"
              tabbar[i+1] = image_tag "tabs/main_tabs_selected_right.gif"
          end
            
        end # if thing.selected
          
          
        tabbar[i] = link_to_tab tab, selected # replace Tab with string
          
      end
        
    end # tabbar.each_with_index {}
      
    tabbar.join ""
  end


  ##############################################################################
  ## Throbber
  ##############################################################################

  def ajax_throbber
    %{
      <script>set_ajax_throbber('ajax_throbber');</script>

      <!-- "Loading..." throbber -->
      <div id="ajax_throbber" style="display: none;">
        <center>
          <img src="/images/throbber-medium.gif" width=45 height=45>
          <h1>Loading...</h1>
        </center>
      </div>
    }
  end

end
