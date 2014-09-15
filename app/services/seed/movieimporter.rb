require 'csv'
require 'pry'
# encoding: UTF-8

class MovieImporter

  attr_reader :file, :options

  def initialize(file, options={})
    @file = file
    @options = default_options.merge(options)
  end

  def import
    puts file
    CSV.foreach(file, options) do |row|
      puts "#{row[:title]}"
      create_movie(row)
      puts 'done'
    end
  end

  def create_movie(attributes)

    movie = Movie.find_by id: attributes[:id]

    if movie.nil?
      movie = Movie.new(id: attributes[:id])
    end

    movie.release_date = attributes[:release_date]
    movie.imdb_url = attributes[:imdb_url]
    movie.title = attributes[:title].gsub(/ \(\d\d\d\d\)/, '').encode('utf-8')
    create_genre_movie(attributes)

    movie.save
  end

  private

  def create_genre_movie(attributes)
    attributes.each do |k, v|
      if v == "1" && k != :id
        puts "#{k}, #{v}"
        subs = {"Scifi" => "Sci-Fi", "Filmnoir" => "Film-Noir"}
        k = k.to_s.capitalize
        subs.each do |error, sub|
          puts k
          puts error
          if k == error
            k = sub
          end
        end

        genre_id = (Genre.find_by name: k.to_s)
        binding.pry if genre_id.nil?
        temp = GenreMovie.find_or_initialize_by(movie_id: attributes[:id], genre_id: genre_id.id)
        temp.save
      end
    end

  end

  def default_options
    { header_converters: :symbol, headers: true, col_sep: '|', encoding: "ISO8859-1" }
  end
end
