require 'spec_helper'

require 'libsql/packer'

describe "::Libsql::Packer" do
  before( :each ) do
    @table = ::Libsql::Requires::Bootstrap::DEFAULT_BOOTSTRAP_TABLE
    @packer = ::Libsql::Packer.new( :table_name => @table )
  end

  after( :each ) do 
    FileUtils.rm_f ::Libsql::Requires::Bootstrap::DEFAULT_DB
  end

  it "does not load the libsql/requires file" do
    $LOADED_FEATURES.should_not be_include("libsql/requires")
  end

  it "packs libsql into a bootstrap database" do
    @packer.pack( ::Libsql::Packer.libsql_require_order )
    db = ::Libsql::Database.new( @packer.dbfile )
    db.schema.tables[ @table ].should_not be_nil
    count = db.execute("SELECT count(1) FROM #{@table}").first
    count.first.should eql(::Libsql::Packer.libsql_require_order.size)
  end

  it "recreates the table if :drop_table option is given " do
    @packer.pack( ::Libsql::Packer.libsql_require_order )
    db = ::Libsql::Database.new( @packer.dbfile )
    db.schema.tables[ @table ].should_not be_nil
    count = db.execute("SELECT count(1) FROM #{@table}").first
    count.first.should eql(::Libsql::Packer.libsql_require_order.size)

    np = ::Libsql::Packer.new( :drop_table => true, :table_name => @table  )
    np.options[ :drop_table ].should eql(true)
    np.check_db( db )
    count = db.execute("SELECT count(1) FROM #{@table}").first
    count.first.should eql(0)

  end

  it "compresses the content if told too" do 
    @packer.options[ :compressed ] = true
    @packer.pack( ::Libsql::Packer.libsql_require_order )
    db = ::Libsql::Database.new( @packer.dbfile )
    orig = IO.read( File.join( File.dirname( __FILE__ ), "..", "lib", "libsql.rb" ) )
    zipped = db.execute("SELECT contents FROM #{@table} WHERE filename = 'libsql'")
    expanded = ::Libsql::Packer.gunzip( zipped.first['contents'].to_s )
    expanded.should eql(orig)
  end

  it "has all the lib files in the libsql gem" do
    ro = ::Libsql::Packer.libsql_require_order
    glist = IO.readlines("Manifest.txt").select { |l| l.index("lib/libsql") == 0 }
    glist.map! { |l| l.strip.sub("lib/","") }
    (glist - ro).each do |l|
      l.should_not =~ /libsql/
    end
  end
end
