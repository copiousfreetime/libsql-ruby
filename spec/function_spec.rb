require 'spec_helper'

describe "Scalar SQL Functions" do

  it "can define a custom SQL function as a block with 0 params" do
    @iso_db.define_function("foo") do 
        "foo"
    end
    r = @iso_db.execute("SELECT foo() AS f");
    r.first['f'].should == "foo"
  end

  it "has a signature" do
    ::Libsql::Function.new( "testing_name", 42 ).signature.should == "testing_name/42"
  end

  it "can define a custom SQL function as a lambda with 2 param" do
    @iso_db.define_function("foo2", lambda{ |x,y| "foo2 -> #{x} #{y}" } )
    r = @iso_db.execute("SELECT foo2( 'bar', 'baz' ) as f")
    r.first['f'].should == "foo2 -> bar baz"
  end

  it "can define a custom SQL function as a class with N params" do
    class FunctionTest1 < ::Libsql::Function
      def initialize
        super('ftest', -1)
      end
      def call( *args )
          "#{args.length} args #{args.join(', ')}"
      end
    end

    @iso_db.define_function("ftest1", FunctionTest1.new )
    r = @iso_db.execute("SELECT ftest1(1,2,3,'baz') as f")
    r.first['f'].should == "4 args 1, 2, 3, baz"
  end

  [ [   1,   lambda { true  } ],
    [   0,   lambda { false } ],
    [   nil, lambda { nil   } ],
    [ "foo", lambda { "foo" } ],
    [ 42,    lambda { 42 }    ],
    [ 42.2 , lambda { 42.2 }  ], ].each do |expected, func|
    it "returns the appropriate class #{expected.class} " do
      @iso_db.define_function("ctest", func )
      r = @iso_db.execute( "SELECT ctest() AS c" )
      r.first['c'].should == expected
    end
  end

  it "does not allow outrageous arity" do
    class FunctionTest3 < ::Libsql::Function
      def initialize
        super( 'ftest3', 128)
      end
    end
    lambda { @iso_db.define_function("ftest3", FunctionTest3.new) }.should raise_error( ::Libsql::SQLite3::Error, /SQLITE_ERROR .* Library used incorrectly/ )
  end

  it "raises an error if the function returns a complex Ruby object" do
    l = lambda { Hash.new }
    @iso_db.define_function("htest", l)
    begin
      @iso_db.execute( "SELECT htest() AS h" ) 
    rescue => e
      e.should be_instance_of( ::Libsql::SQLite3::Error )
      e.message.should =~ /Unable to convert ruby object to an SQL function result/
    end
  end

  it "an error raised during the sql function is handled correctly" do
    @iso_db.define_function( "etest" ) do 
      raise "error from within an sql function"
    end
    lambda { @iso_db.execute( "SELECT etest() AS e" ) }.should raise_error( ::Libsql::SQLite3::Error, /error from within an sql function/ )
  end
end

