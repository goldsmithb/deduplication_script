# ////////////// GLOBALS \\\\\\\\\\\\\\\
HELP_STR = "This script allows you to specify two CSV files containing AWS\n"\
          " data, and output a csv that has identified duplicate records.\n"\
          " It supports the following commands:\n" \
          " \t-f <file1> <file2>\tSpecify csv files for comparison\n" \
          " \t-h\t\t\tDisplay this message\n\n".freeze

# The column names for the output CSV files
RET_HEADERS = ['object1_s3_uri',
               'object2_s3_uri',
               'object1_s3_etag',
               'object1_s3_etag',
               'object1_s3_size',
               'object1_s3_size',
               'comparison_result'].freeze

OUTPUT = 'matches.csv'.freeze

# ////////////// HELPERS \\\\\\\\\\\\\\\
def bad_cl_args
  abort "Bad command line arguments: Use '-h' to view usage instructions."
end

def print_hash(hash)
  hash.each { |k, v| puts "#{k} ==> #{v}" }
  puts 'DONE'
end

def get_name_from_key(key)
  # key = "s3/../.../.../name"
  strs = key.split('/')
  strs[-1]
end

# expects a hash with the following structure:
# {
#   :etag_same => boolean,
#   :name_same => boolean,
#   :size_same => boolean,
# }
def comparison_result(cmp)
  # If the names do not match, there is no chance they are the same file
  # This is suspicious, however -- this is the collision case
  unless cmp[:name_same]
    puts 'Suspicious record (possible hash collision, names do not match)'
    return 'no match'
  end

  if cmp[:etag_same] && cmp[:size_same]
    'exact match'
  else
    'possible match'
  end
end

def res_row(row1, row2, res)
  cmp_res = comparison_result(res)
  [
    row1['key'],  # "object1_s3_uri",
    row2['key'],  # "object2_s3_uri",
    row1['etag'], # "object1_s3_etag",
    row2['etag'], # "object1_s3_etag",
    row1['size'], # "object1_s3_size",
    row2['size'], # "object1_s3_size",
    cmp_res       # "comparison_result"
  ]
end
