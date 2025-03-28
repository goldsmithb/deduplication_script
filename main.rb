#!/usr/env ruby

# Require all gems in Gemfile
require 'bundler'
Bundler.require(:default)

# Auto-load all files in lib directory
loader = Zeitwerk::Loader.new
loader.push_dir('lib')
loader.setup # ready!

# Run code!
# NB Assumes sufficiently small enough CSV files to load entirely into memory
# ////////////// SCRIPT  \\\\\\\\\\\\\\\

abort "Error: No arguments provided. Use '-h' to view usage instructions." if ARGV.empty?

case ARGV[0]
when '-h'
  puts HELP_STR
  return
when '-f'
  if ARGV.length != 3
    bad_cl_args
    return
  end
  file1 = ARGV[1]
  file2 = ARGV[2]
else
  file1 = 'csv1_test.csv'
  file2 = 'csv2_test.csv'
  # bad_cl_args
end

# Create Comparer object
# We must compare in both directions. We will begin by going from records in file1 to file2
# Later we can call Comparer.swap_target repeat the process
comparer = Comparer.new(file1, file2)
puts '------------------------------'
puts comparer.csv1
puts '------------------------------'
puts comparer.csv2
puts '------------------------------'

# Create hashmap of first csv file for quick lookup
# etag => [row,...]
comparer.populate_hash
comparer.print_etag_hash

# Create output table for our results
comparer.init_output_table

# Run comparison
comparer.compare

# puts comparer.matches_csv

# puts "#{csv1_hash}"

# csv1.forEach do |row|
#   p row
# end
# p file2

# iterate over longer csv
