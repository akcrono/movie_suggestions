require 'csv'
require 'pry'
# encoding: UTF-8

class MovieImporter
  attr_reader :file, :options

  def initialize(file, options = {})
    @file = file
    @options = default_options.merge(options)
  end

  def import
    puts "movies started"
    CSV.foreach(file, options) do |row|
      create_movie(row)
    end
    puts "movies complete"
  end

  def create_movie(attributes)
    movie = Movie.find_or_initialize_by id: attributes[:id]

    movie.release_date = attributes[:release_date]
    movie.imdb_url = attributes[:imdb_url]
    movie.title = attributes[:title].gsub(/ \(\d\d\d\d\)/, '').encode('utf-8')
    movie.average_rating = calculate_average_rating(attributes[:id])
    create_genre_movie(attributes)

    movie.save
  end

  private

  def create_genre_movie(attributes)
    attributes.each do |k, v|
      if v == "1" && k != :id
        subs = { "Scifi" => "Sci-Fi", "Filmnoir" => "Film-Noir" }
        k = k.to_s.capitalize

        subs.each do |error, sub|
          if k == error
            k = sub
          end
        end

        genre_id = (Genre.find_by name: k.to_s)
        temp = GenreMovie.find_or_initialize_by(movie_id: attributes[:id],
                                                genre_id: genre_id.id)
        temp.save
      end
    end
  end

  def calculate_average_rating(movie_id)
    rating_sum = 0
    ratings = Review.where(movie_id: movie_id)
    ratings.each { |x| rating_sum += x.rating }
    rating_sum.to_f / ratings.count
  end

  def default_options
    { header_converters: :symbol,
      headers: true, col_sep: '|',
      encoding: "ISO8859-1" }
  end
end
