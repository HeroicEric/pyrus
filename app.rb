require 'dotenv'
Dotenv.load

require 'fileutils'
require 'csv'

class Pyrus
  MENTOR = ENV['MENTOR']
  COHORT = ENV['COHORT']
  PEOPLE = ENV['PEOPLE'].split(', ')

  DIRECTORY = "pairs/#{COHORT}"
  FILE_PATH = "#{DIRECTORY}/#{MENTOR}.csv"

  def initialize
    unless File.directory?(DIRECTORY)
      Dir.mkdir DIRECTORY
      FileUtils.touch(FILE_PATH)
    end

    @previous_pairs = load_previous_pairs
  end

  def make_pairs
    pairs = []

    loop do
      attempted_pairs = []
      PEOPLE.shuffle.each_slice(2) do |pair|
        attempted_pairs << pair
      end

      if pairs_are_new?(attempted_pairs)
        pairs = attempted_pairs
        break
      end
    end

    pairs
  end

  def generate_pairs
    pairs = make_pairs
    save_pairs(pairs)
    display_pairs(pairs)
  end

  def save_pairs(pairs)
    CSV.open(FILE_PATH, "a+") do |csv|
      pairs.each do |pair|
        csv << pair
      end
    end
  end

  def display_pairs(pairs)
    pairs.each_with_index do |pair, index|
      puts "#{index + 1}. #{pair[0]} and #{pair[1]}."
    end
  end

  def load_previous_pairs
    CSV.read(FILE_PATH)
  end

  def pairs_are_new?(pairs)
    pairs_are_new = true
    pairs.each do |pair|
      if @previous_pairs.include?(pair) || @previous_pairs.include?(pair.reverse)
        pairs_are_new = false
      end
    end
    pairs_are_new
  end
end

pyrus = Pyrus.new
pyrus.generate_pairs
