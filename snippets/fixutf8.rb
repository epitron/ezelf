require './config/environment.rb'

#[#<Track id: 57949, 
#title: "White & Nerdy", album_id: 4021, number: "01", disc: nil, artist_id: nil, 
#relative_path: "Weird Al Yankovic - Straight Outta Lynwood (2006)", 
#filename: "01-weird_al_yankovic-white_and_nerdy.mp3", source_id: 1, length: 169.468, bitrate: 218, vbr: true, updated_at: "2007-09-24 06:41:34", created_at: "2007-09-24 06:41:34", bytes: 4756992, ctime: "2007-09-23 11:52:27", mtime: "2007-09-23 11:52:27">

def fixutf8(s); s.encode("cp1252").force_encoding("utf-8"); end

fields = %w[relative_path filename title]

Track.all.each do |t|
  #fields.each { |f| p [f, t.attributes[f]] }
  hash = Hash[ fields.map { |f| val = t.attributes[f]; [f, fixutf8(val)] unless val.nil? }.compact ]
  t.update_attributes(hash)
  #p updating_to: hash
end
  
