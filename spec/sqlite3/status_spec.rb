require 'spec_helper'
require 'libsql/sqlite3'
require 'rbconfig'

describe "::Libsql::SQLite3::Status" do
  it "knows how much memory it has used" do
    ::Libsql::SQLite3.status.memory_used.current.should be >= 0
    ::Libsql::SQLite3.status.memory_used.highwater.should be >= 0
  end

  it "can reset the highwater value" do
    before = ::Libsql::SQLite3.status.memory_used.highwater
    before.should be > 0

    current = ::Libsql::SQLite3.status.memory_used.current
    ::Libsql::SQLite3.status.memory_used.reset!
    ::Libsql::SQLite3.status.memory_used.highwater.should be == current

    after = ::Libsql::SQLite3.status.memory_used.highwater
    after.should_not eql(before)
  end
end
