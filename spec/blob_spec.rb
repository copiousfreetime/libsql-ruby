require 'spec_helper'

describe ::Libsql::Blob do

  before(:each) do
    @blob_db_name = File.join(File.dirname( __FILE__ ), "blob.db")
    File.unlink @blob_db_name if File.exist?( @blob_db_name )
    @db = ::Libsql::Database.new( @blob_db_name )
    @schema_sql = <<-SQL
      CREATE TABLE blobs(
        id      INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        name    VARCHAR(128) NOT NULL UNIQUE,
        data    TEXT ); 
    SQL
    @db.execute( @schema_sql )
    @country_data_file = ::Libsql::Iso3166Database.country_data_file
    @junk_file = File.join( File.dirname(__FILE__), "test_output")
  end

  after(:each) do
    @db.close
    File.unlink @blob_db_name if File.exist?( @blob_db_name )
    File.unlink @junk_file    if File.exist?( @junk_file )
  end

  { :file   => ::Libsql::Iso3166Database.country_data_file,
    :string => IO.read( ::Libsql::Iso3166Database.country_data_file),
    :io     => StringIO.new( IO.read( ::Libsql::Iso3166Database.country_data_file) ) }.each_pair do |style, data |
    describe "inserts a blob from a #{style}" do
      before(:each) do
        column = @db.schema.tables['blobs'].columns['data']
        @db.execute("INSERT INTO blobs(name, data) VALUES ($name, $data)",
                    { "$name" => @country_data_file,
                      "$data" => ::Libsql::Blob.new( style => data,
                                                      :column => column ) } )
        @db.execute("VACUUM")
      end

      after(:each) do
        @db.execute("DELETE FROM blobs")
        data.rewind if data.respond_to?( :rewind )
      end

      it "and retrieves the data as a single value" do
        all_rows = @db.execute("SELECT name,data FROM blobs")
        all_rows.size.should eql(1)
        all_rows.first['name'].should eql(@country_data_file)
        all_rows.first['data'].should_not be_incremental
        all_rows.first['data'].to_string_io.string.should eql(IO.read( @country_data_file ))
      end

      it "and retrieves the data using incremental IO" do
        all_rows = @db.execute("SELECT * FROM blobs")
        all_rows.size.should eql(1)
        all_rows.first['name'].should eql(@country_data_file)
        all_rows.first['data'].should be_incremental
        all_rows.first['data'].to_string_io.string.should eql(IO.read( @country_data_file ))
      end

      it "writes the data to a file " do
        all_rows = @db.execute("SELECT * FROM blobs")
        all_rows.size.should eql(1)
        all_rows.first['name'].should eql(@country_data_file)
        all_rows.first['data'].should be_incremental
        all_rows.first['data'].write_to_file( @junk_file )
        IO.read( @junk_file).should eql(IO.read( @country_data_file ))
      end
    end
  end



  it "raises an error if initialized incorrectly" do
    lambda{ ::Libsql::Blob.new( :file => "/dev/null", :string => "foo" ) }.should raise_error( ::Libsql::Blob::Error )
  end
end


