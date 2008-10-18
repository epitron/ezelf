class CreateEncodings < ActiveRecord::Migration
  def self.up
    create_table :encodings do |t|
      t.string :name
      t.string :description
    end

    change_table :sources do |t|
      t.remove :encoding
      t.integer :encoding_id, :default => 1
    end

    # http://www.basis.com/onlinedocs/documentation/inst/character_encoding.htm    
    Encoding.create :id=>1, :name=>'UTF-8', :description=>'UTF-8 (Unix)'
    Encoding.create :id=>2, :name=>'ISO-8859-1', :description=>'ISO-8859-1 (Windows)'
    Encoding.create :id=>3, :name=>'Cp1252', :description=>'Cp1252 (Windows)'
  end

  def self.down
    drop_table :encodings
    change_table :sources do |t|
      t.remove :encoding_id
      t.string :encoding
    end
  end
end
