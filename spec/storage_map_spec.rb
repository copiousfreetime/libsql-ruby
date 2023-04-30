require 'spec_helper'
require 'libsql/type_maps/storage_map'

describe ::Libsql::TypeMaps::StorageMap do
  before(:each) do
    @map = ::Libsql::TypeMaps::StorageMap.new
  end

  describe "#bind_type_of" do

    it "Float is bound to DataType::FLOAT" do
      @map.bind_type_of( 3.14 ).should == ::Libsql::SQLite3::Constants::DataType::FLOAT
    end

    it "Integer is bound to DataType::INTGER" do
      @map.bind_type_of( 42 ).should == ::Libsql::SQLite3::Constants::DataType::INTEGER
    end

    it "nil is bound to DataType::NULL" do
      @map.bind_type_of( nil ).should == ::Libsql::SQLite3::Constants::DataType::NULL
    end

    it "::Libsql::Blob is bound to DataType::BLOB" do
      @map.bind_type_of( ::Libsql::Blob.new( :string => "testing mapping", :column => true )  ).should == ::Libsql::SQLite3::Constants::DataType::BLOB
    end

    it "everything else is bound to DataType::TEXT" do
      @map.bind_type_of( "everything else" ).should == ::Libsql::SQLite3::Constants::DataType::TEXT
    end

  end

  describe "#result_value_of" do
    it "returns the original object for everything passed in" do
      @map.result_value_of( "doesn't matter", 42 ).should == 42
    end
  end
end
