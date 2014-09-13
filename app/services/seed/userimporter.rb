require 'csv'
require 'pry'

class UserImporter
  attr_reader :file, :options

  def initialize(file, options={})
    @file = file
    @options = default_options.merge(options)
  end

  def import
    CSV.foreach(file, options) do |row|
      create_user(row)
    end
  end

  def create_user(attributes)

    user = User.find_by id: attributes[:id]

    if user.nil?
      user = User.new(id: attributes[:id])
    end
    user.age = attributes[:name]
    user.gender = attributes[:gender]
    user.occupation = attributes[:occupation]
    user.zip_code = attributes[:zip_code]
    user.save
  end

  private

  def default_options
    { header_converters: :symbol, headers: true, col_sep: '|' }
  end
end
