require 'csv'
require_relative "utils" # needed to invoke print_hash from utils.... zeitwerk should have taken care of this...

class Comparer
  attr_accessor :csv1, :csv2, :current, :target_csv, :etag_hash
  attr_reader :matches_csv

  def initialize(file1, file2)
    @csv1 = CSV.parse(File.read(file1), headers: true, converters: :integer).by_row! # returns a CSV::table
    @csv2 = CSV.parse(File.read(file2), headers: true, converters: :integer).by_row!
    @current = @csv1
    @target = @csv2
  end

  def init_output_table
    File.delete(OUTPUT) if File.file?(OUTPUT)
    @matches_csv = CSV.open(OUTPUT, 'wx+')
  end

  def print_etag_hash
    print_hash(@etag_hash)
  end

  # Hash the csv stored in @target
  # We hash the 'etag' field, and map to an array of rows
  # Notifies stdout if there are any collisions
  def populate_hash
    @etag_hash = {}
    @target.each do |row|
      puts 'populate_hash: collision detected!' if @etag_hash[row['etag']] != nil
      @etag_hash[row['etag']] ||= []
      @etag_hash[row['etag']].push(row)
    end
  end

  # Compares the values of @current with those in @target
  # We will check every record in @target. We will only search for records
  # in @current by etag lookup in @etag_hash table.
  # Writes results to the @matches_csv file
  def compare
    @target.each do |row|
      puts "currently looking at #{row['key']}"
      res = Hash.new(false)
      if @etag_hash[row['etag']] != nil
        puts 'Matching etag found!'
        res[:etag_same] = true
        hashed = @etag_hash[row['etag']] # a list
        hashed.each do |hashed_row|
          res[:name_same] = true if get_name_from_key(hashed_row['key']) == get_name_from_key(row['key'])
          res[:size_same] = true if hashed_row['size'] == row['size']
          # construct row to add to matches.csv
          @matches_csv << res_row(hashed_row, row, res)
        end
      else
        puts 'no match!'
      end
    end
  end
end
