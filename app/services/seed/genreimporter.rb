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
    genre = Genre.find_by id: attributes[:id]

    if genre.nil?
      genre = Genre.new(id: attributes[:id], name: attributes[:name])
    else
      genre.name = attributes[:name]
    end
    genre.save
  end

  private

  def default_options
    { header_converters: :symbol, headers: true, col_sep: '|' }
  end
end
