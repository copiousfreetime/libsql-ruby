require 'spec_helper'
require 'libsql/sqlite3/libsql_version'

describe "::Libsql::SQLite3::LibsqlVersion" do
  it "should have the libsql version" do
    expect(::Libsql::SQLite3::LIBSQL_VERSION).to match(/\d+\.\d+\.\d+/)
    expect(::Libsql::SQLite3::LibsqlVersion.to_s).to match(/\d+\.\d+\.\d+/)
    expect(::Libsql::SQLite3::LibsqlVersion.runtime_version).to match( /\d+\.\d+\.\d+/ )
    expect(::Libsql::SQLite3::LibsqlVersion.compiled_version).to match( /\d+\.\d+\.\d+/ )

    ::Libsql::SQLite3::LIBSQL_VERSION.should be == "0.2.1"
    ::Libsql::SQLite3::LibsqlVersion.compiled_version.should be == "0.2.1"
    ::Libsql::SQLite3::LibsqlVersion.runtime_version.should be == "0.2.1"
    ::Libsql::SQLite3::LibsqlVersion.to_s.should be == "0.2.1"
  end
end
