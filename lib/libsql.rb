#--
# Copyright (c) 2023 Jeremy Hinegardner
# All rights reserved.  See LICENSE and/or COPYING for details.
#++

# check if sqlite3 has already been required.  ::Libsql conflicts with system
# level sqlite3 libraries.
unless $LOADED_FEATURES.grep( /\Asqlite3/ ).empty? then
  raise LoadError, "libsql conflicts with sqlite3, please choose one or the other."
end

module ::Libsql
  # 
  # Base class of all errors in ::Libsql
  #
  class Error < ::StandardError; end
end

# Load the binary extension, try loading one for the specific version of ruby
# and if that fails, then fall back to one in the top of the library.
# this is the method recommended by rake-compiler
begin
  # this will be for windows
  require "libsql/#{RUBY_VERSION.sub(/\.\d+$/,'')}/libsql_ext"
rescue LoadError
  # everyone else.
  require 'libsql/libsql_ext'
end


require 'libsql/aggregate'
require 'libsql/blob'
require 'libsql/boolean'
require 'libsql/busy_timeout'
require 'libsql/column'
require 'libsql/database'
require 'libsql/function'
require 'libsql/index'
require 'libsql/memory_database'
require 'libsql/paths'
require 'libsql/profile_tap'
require 'libsql/progress_handler'
require 'libsql/schema'
require 'libsql/sqlite3'
require 'libsql/statement'
require 'libsql/table'
require 'libsql/taps'
require 'libsql/trace_tap'
require 'libsql/type_map'
require 'libsql/version'
require 'libsql/view'
