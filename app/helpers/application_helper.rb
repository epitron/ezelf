# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def streamlined_top_menus
		[
			["Home", { :controller => "browse", :action => "index" }],
			["Users", { :controller => "users", :action => "index" }],
		]
	end

end
