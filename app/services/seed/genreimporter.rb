require 'csv'
require 'pry'

class GenreImporter
  attr_reader :file, :options

  def initialize(file, options = {})
    @file = file
    @options = default_options.merge(options)
  end

  def import
    CSV.foreach(file, options) do |row|
      create_genre(row)
    end
  end

  def create_genre(attributes)
    genre = Genre.find_or_initialize_by id: attributes[:id]
    genre.name = attributes[:name]
    genre.save
  end

  private

  def default_options
    { header_converters: :symbol, headers: true, col_sep: '|' }
  end
end
