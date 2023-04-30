require 'amalgalite'
require 'pathname'
require 'zlib'
require 'amalgalite/packer'

module Amalgalite
  #
  # Requires encapsulates requiring items from the database
  #
  class Requires
    class << self
      def load_path_db_connections
        @load_path_db_connections ||= {}
      end

      def load_path
        @load_path ||= []
      end

      #
      # Allocate a database connection to the given filename. For
      # file databases, this means giving the same connection
      # back if you ask for a connection to the same file.
      # For in-memory databases, you get a new one each time.
      #
      def db_connection_to( dbfile_name )
        if dbfile_name == ":memory:"
          return ::Amalgalite::Database.new( dbfile_name )
        else
          unless connection = load_path_db_connections[ dbfile_name ] 
            connection = ::Amalgalite::Database.new( dbfile_name )
            load_path_db_connections[dbfile_name] = connection
          end
          return connection
        end
      end

      #
      # Setting a class level variable as a flag to know what we are currently
      # in the middle of requiring
      #
      def requiring
        @requiring ||= []
      end

      def require( filename )
        if load_path.empty? then
          raise ::LoadError, "Amalgalite load path is empty -- #{filename}"
        elsif $LOADED_FEATURES.include?( filename ) then
          return false
        elsif Requires.requiring.include?( filename ) then 
          return false
        else
          Requires.requiring << filename
          load_path.each do |lp|
            if lp.require( filename ) then
              Requires.requiring.delete( filename )
              return true
            end
          end
          Requires.requiring.delete( filename )
          raise ::LoadError, "amalgalite has no such file to load -- #{filename}"
        end
      end
    end

    attr_reader :dbfile_name
    attr_reader :table_name
    attr_reader :filename_column
    attr_reader :contents_column
    attr_reader :compressed_column
    attr_reader :db_connection

    def initialize( opts = {} )
      @dbfile_name       = opts[:dbfile_name]       || Bootstrap::DEFAULT_DB
      @table_name        = opts[:table_name]        || Bootstrap::DEFAULT_TABLE
      @filename_column   = opts[:filename_column]   || Bootstrap::DEFAULT_FILENAME_COLUMN
      @contents_column   = opts[:contents_column]   || Bootstrap::DEFAULT_CONTENTS_COLUMN
      @compressed_column = opts[:compressed_column] || Bootstrap::DEFAULT_COMPRESSED_COLUMN
      @db_connection   = Requires.db_connection_to( dbfile_name )
      Requires.load_path << self
    end

    #
    # return the sql to find the file contents for a file in this requires
    #
    def sql
      @sql ||= "SELECT #{filename_column}, #{compressed_column}, #{contents_column} FROM #{table_name} WHERE #{filename_column} = ?"
    end

    #
    # load a file in this database table.  This will check and see if the
    # file is already required.  If it isn't it will select the contents
    # associated with the row identified by the filename and eval those contents
    # within the context of TOPLEVEL_BINDING.  The filename is then appended to
    # $LOADED_FEATURES.
    #
    # if the file was required then true is returned, otherwise false 
    #
    def require( filename )
      if $LOADED_FEATURES.include?( filename ) then
        return false
      else
        begin
          filename = filename.gsub(/\.rb\Z/,'')

          contents = file_contents(filename)

          if contents
            eval( contents, TOPLEVEL_BINDING, filename )
            $LOADED_FEATURES << filename
            return true
          else
            return false
          end
        rescue => e
          raise ::LoadError, "Failure loading #{filename} from #{dbfile_name} : #{e}"
        end
      end
    end

    # 
    # Return the contents of the named file.
    #
    def file_contents(filename)
      rows = db_connection.execute(sql, filename)
      if rows.size > 0 then
        row = rows.first

        contents = row[contents_column].to_s
        if row[compressed_column] then 
          contents = ::Amalgalite::Packer.gunzip( contents )
        end
        
        return contents
      else
        return nil
      end
    end

    
    #
    # Import an SQL dump into the fake file system.
    #
    def import(sql)
      db_connection.import(sql)
    end

  end
end
require 'amalgalite/core_ext/kernel/require'
