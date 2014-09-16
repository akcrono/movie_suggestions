
require 'csv'

GenreImporter.new('data/u.genre').import
puts "Genre complete"
UserImporter.new('data/u.user').import
# keep commented out unless needed; the load time is very high
ReviewImporter.new('data/u.data', col_sep: "\t").import
MovieImporter.new('data/u.item').import
