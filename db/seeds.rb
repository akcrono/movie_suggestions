
require 'csv'

GenreImporter.new('data/u.genre').import
puts "Genre complete"
UserImporter.new('data/u.user').import
puts "user complete"
#keep the following line commented out unless needed; the load time is very high
#ReviewImporter.new('data/u.data', col_sep: "\t").import
puts "reviews complete"
MovieImporter.new('data/u.item').import
