require 'csv'
require 'pry'

class ReviewImporter
  attr_reader :file, :options

  def initialize(file, options = {})
    @file = file
    @options = default_options.merge(options)
  end

  def import
    count = 0
    puts "reviews started, completing:"
    CSV.foreach(file, options) do |row|
      create_review(row)
      count += 1
      if count % 1000 == 0
        puts "Loaded: #{count}"
      end
    end
    puts "reviews complete"
  end

  def create_review(attributes)
    review = Review.find_by user_id: attributes[:user_id],
                            movie_id: attributes[:movie_id]
    if review.nil?
      review = Review.create(user_id: attributes[:user_id],
                             movie_id: attributes[:movie_id],
                             rating: attributes[:rating])
    end
  end

  private

  def default_options
    { header_converters: :symbol, headers: true, col_sep: '|' }
  end
end
