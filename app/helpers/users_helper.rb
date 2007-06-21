module UsersHelper
	def streamlined_side_menus
		[
			["New", { :action => "create" }],
			["List", { :action => "index" }],
		]
	end
end
