###########################################################
## MonkeyPatches!

class ActiveRecord::Base

	# Return a unique identifier for this record, for tagging html elements with
	# "id" attributes
	def html_id
		"#{self.class.table_name}_#{self.id}"
	end
end


class Array
	def smoosh
		self.flatten.compact.uniq
	end
end