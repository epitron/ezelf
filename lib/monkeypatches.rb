###########################################################
## MonkeyPatches!

class ActiveRecord::Base

  # Return a unique identifier for this record, for tagging html elements with
  # "id" attributes
  def html_id
    "#{self.class.table_name}_#{self.id}"
  end

  def self.reset_autoindex
    last = self.find(:first, :order=>"#{self.primary_key} desc")
    next_id = last ? last.id + 1 : 1
    sql = "ALTER TABLE `#{self.table_name}` AUTO_INCREMENT = #{next_id}"
    puts "* Resetting autoindex on #{self.table_name.inspect} to #{next_id}"
    self.connection.execute(sql)
  end

  def self.truncate!
    puts "* Truncating #{self.table_name.inspect}"
    self.connection.execute("TRUNCATE TABLE `#{self.table_name}`")
    self.reset_autoindex
  end
  
end


class Array
  def smoosh
    self.flatten.compact.uniq
  end
end


class String
  def escape_single_quotes
    self.gsub(/[']/, '\\\\\'')
  end
end


