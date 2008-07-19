require 'iconv'
require 'config/environment'

coconut = Artist.find 6687
puts "native: #{coconut.name}"
puts "latin->utf-8: #{Iconv.iconv('UTF8','LATIN1', coconut.name)}"

