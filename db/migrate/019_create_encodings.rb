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
    
    Encoding.create :id=>1, :name=>'UTF-8', :description=>'UTF-8 (Unix)'
    Encoding.create :id=>2, :name=>'ISO-8859-1', :description=>'ISO-8859-1 (DOS)'
  end

  def self.down
    drop_table :encodings
    change_table :sources do |t|
      t.remove :encoding_id
      t.string :encoding
    end
  end
end
