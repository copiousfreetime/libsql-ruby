require 'spec_helper'

require 'libsql'
require 'libsql/trace_tap'
require 'libsql/profile_tap'
require 'libsql/taps/console'
require 'stringio'

describe ::Libsql::TraceTap do
  it "wraps up an object and delegates the 'trace' method to a method on that object" do
    s = StringIO.new
    tt = ::Libsql::TraceTap.new( s, 'puts' )
    tt.trace('test trace')
    s.string.should eql("test trace\n")
  end
  
  it "raises an error if an the wrapped object does not respond to the indicated method"  do
    lambda{ ::Libsql::TraceTap.new( Object.new ) }.should raise_error( ::Libsql::Error )
  end
end

describe ::Libsql::ProfileTap do
  it "raises an error if an the wrapped object does not respond to the indicated method"  do
    lambda{ ::Libsql::ProfileTap.new( Object.new ) }.should raise_error( ::Libsql::Error )
  end
end

describe ::Libsql::Taps::StringIO do
  it "dumps profile information" do
    s = ::Libsql::Taps::StringIO.new
    s.profile( 'test', 42 )
    s.dump_profile
    s.string.should eql("42 : test\n[test] => sum: 42, sumsq: 1764, n: 1, mean: 42.000000, stddev: 0.000000, min: 42, max: 42\n")
  end

  it "has a stdout tap" do
    ::Libsql::Taps::Stdout.new
  end

  it "has a stderr tap" do
    ::Libsql::Taps::Stderr.new
  end
end

describe ::Libsql::ProfileSampler do
  it "aggregates samples" do
    s = ::Libsql::ProfileSampler.new( 'test1' )
    s.sample( 42 )
    s.sample( 84 )
    s.sample( 21 )
    h = s.to_h
    h['min'].should eql(21)
    h['max'].should eql(84)
    h['mean'].should eql(49.0)
    h['n'].should eql(3)
  end
end
