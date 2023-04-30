require 'spec_helper'
require 'libsql/sqlite3'
require 'rbconfig'

describe "::Libsql::SQLite3::Database::Status" do
  before(:each) do
    @db = ::Libsql::Database.new( "lookaside-test.db" )
    @db.execute(" create table t(a, b)")
    20.times do |x|
      @db.execute("insert into t(a, b) values (?,?);", x, x+1)
    end
  end

  after(:each) do
    @db.close
    ::FileUtils.rm_f "lookaside-test.db" 
  end


  it "knows how much lookaside memory it has used" do
    @db.api.status.lookaside_used.highwater.should be > 0
    @db.api.status.lookaside_used.current.should be >= 0
  end

  it "can reset the highwater value" do
    stat = @db.api.status.lookaside_used
    before = stat.highwater
    before.should be > 0

    stat.reset!
    after = stat.highwater

    after.should eql(0)
    after.should_not eql(before)
  end
end
