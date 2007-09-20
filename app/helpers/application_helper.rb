# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    def streamlined_top_menus
        [
            ["Home", { :controller => "browse", :action => "index" }],
            ["Users", { :controller => "users", :action => "index" }],
            ["Sources", { :controller => "sources", :action => "index" }],
        ]
    end
    
    
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
        Tab.new( "home",     { :controller => "browse", :action => "index"  }  ),
        Tab.new( "artists",  { :controller => "browse", :action => "artists"  }  ),
        Tab.new( "files",    { :controller => "browse", :action => "files"    }  ),
        #Tab.new( "users",    { :controller => "users",  :action => "list"     }  ),
        Tab.new( "shuffle",  { :controller => "stream", :action => "shuffle"  }  ),
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
      

end
