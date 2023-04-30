require 'rspec'
require 'fileutils'

require 'libsql'
require ::Libsql::Paths.spec_path( "iso_3166_database.rb" )

class SpecInfo
  class << self
    def test_db
      @test_db ||= ::Libsql::Paths.spec_path("data", "test.db")
    end

    def make_master_iso_db
      @master_db ||= ::Libsql::Iso3166Database.new
    end

    def make_clone_iso_db
      make_master_iso_db.duplicate( 'testing' )
    end
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.before(:all) do 
    SpecInfo.make_master_iso_db
  end

  config.after(:all) do
    File.unlink( ::Libsql::Iso3166Database.default_db_file ) if File.exist?( ::Libsql::Iso3166Database.default_db_file )
  end

  config.before( :each ) do
    @iso_db_path = SpecInfo.make_clone_iso_db
    @iso_db      = ::Libsql::Database.new( @iso_db_path )
    @schema      = IO.read( ::Libsql::Iso3166Database.schema_file )
  end

  config.after( :each ) do
    @iso_db.close
    File.unlink( @iso_db_path ) if File.exist?( @iso_db_path )
    File.unlink( SpecInfo.test_db ) if File.exist?( SpecInfo.test_db )
  end
end

