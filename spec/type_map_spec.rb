require 'spec_helper'
require 'libsql/type_map'

describe ::Libsql::TypeMap do
  it "#bind_type_of raises NotImplemented error" do
    tm = ::Libsql::TypeMap.new
    lambda { tm.bind_type_of( Object.new ) }.should raise_error( NotImplementedError )
  end

  it "#result_value_of raises NotImplemented error" do
    tm = ::Libsql::TypeMap.new
    lambda { tm.result_value_of( "foo", Object.new ) }.should raise_error( NotImplementedError )
  end
end
