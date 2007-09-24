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

class Object
  def my_methods
    self.methods - Object.instance_methods
  end
end

class String
  def escape_single_quotes
    self.gsub(/[']/, '\\\\\'')
  end
end

