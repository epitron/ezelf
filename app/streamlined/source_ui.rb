class SourceUI < Streamlined::UI
  ENCODINGS = {
	'UTF-8 (Unix)' => 'UTF-8',
	'ISO-8859-1 (DOS)' => 'ISO-8859-1' 
  }

  #user_columns :id, :name, :uri, :description
  quick_delete_button true
  user_columns 	:name, { :human_name => 'Nickname' }, 
  				:uri, { :human_name => "Path or URI" },
                :encoding, { :enumeration => ENCODINGS }
end
