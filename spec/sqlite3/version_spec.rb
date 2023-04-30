require 'spec_helper'
require 'libsql/sqlite3/version'

describe "::Libsql::SQLite3::Version" do
  it "should have the sqlite3 version" do
    expect(::Libsql::SQLite3::VERSION).to match(/\d+\.\d+\.\d+/)
    expect(::Libsql::SQLite3::Version.to_s).to match( /\d+\.\d+\.\d+/ )
    expect(::Libsql::SQLite3::Version.runtime_version).to match( /\d+\.\d+\.\d+/ )

    ::Libsql::SQLite3::Version.to_i.should eql(3042000)
    ::Libsql::SQLite3::Version.runtime_version_number.should eql(3042000)

    ::Libsql::SQLite3::Version::MAJOR.should eql(3)
    ::Libsql::SQLite3::Version::MINOR.should eql(42)
    ::Libsql::SQLite3::Version::RELEASE.should eql(0)
    expect(::Libsql::SQLite3::Version.to_a.size).to eql(3)

    ::Libsql::SQLite3::Version.compiled_version.should be == "3.42.0"
    ::Libsql::SQLite3::Version.compiled_version_number.should be == 3042000
    ::Libsql::SQLite3::Version.compiled_matches_runtime?.should be == true
  end

  it "should have the sqlite3 source id" do
    source_id = "2023-03-11 23:21:21 dc9f025dc43cb8008e7d8d644175d8b2d084e602a1513803c40c513d1e99alt1"
    ::Libsql::SQLite3::Version.compiled_source_id.should be == source_id
    ::Libsql::SQLite3::Version.runtime_source_id.should be == source_id
  end
end
