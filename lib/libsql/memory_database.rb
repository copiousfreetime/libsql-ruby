require 'libsql/database'
module ::Libsql
  #
  # The encapsulation of a connection to an SQLite3 in-memory database.  
  #
  # Open an in-memory database:
  #
  #   db = ::Libsql::MemoryDatabase.new
  #
  class MemoryDatabase < Database
    def initialize
      super( ":memory:" )
    end
  end
end
