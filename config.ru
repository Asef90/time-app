require_relative 'app'
require_relative 'middleware/query_parser'

use QueryParser
run App.new
