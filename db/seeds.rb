
require 'csv'

GenreImporter.new('data/u.genre').import
puts "Genre complete"
UserImporter.new('data/u.user').import
puts "user complete"
#ReviewImporter.new('data/u.data', col_sep: "\t").import
puts "reviews complete"
