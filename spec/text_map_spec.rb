require 'spec_helper'
require 'libsql/type_maps/text_map'

describe ::Libsql::TypeMaps::TextMap do
  before(:each) do
    @map = ::Libsql::TypeMaps::TextMap.new
  end

  describe "#bind_type_of" do
    it "returnes text for everything" do
      @map.bind_type_of( 3.14 ).should == ::Libsql::SQLite3::Constants::DataType::TEXT
    end
  end

  describe "#result_value_of" do
    it "returns the string value of the object for everything passed in" do
      @map.result_value_of( "doesn't matter", 42 ).should == "42"
    end
  end
end
