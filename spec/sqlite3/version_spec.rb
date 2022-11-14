require 'spec_helper'
require 'amalgalite/sqlite3/version'

describe "Amalgalite::SQLite3::Version" do
  it "should have the sqlite3 version" do
    expect(Amalgalite::SQLite3::VERSION).to match(/\d+\.\d+\.\d+/)
    expect(Amalgalite::SQLite3::Version.to_s).to match( /\d+\.\d+\.\d+/ )
    expect(Amalgalite::SQLite3::Version.runtime_version).to match( /\d+\.\d+\.\d+/ )

    Amalgalite::SQLite3::Version.to_i.should eql(3039004)
    Amalgalite::SQLite3::Version.runtime_version_number.should eql(3039004)

    Amalgalite::SQLite3::Version::MAJOR.should eql(3)
    Amalgalite::SQLite3::Version::MINOR.should eql(39)
    Amalgalite::SQLite3::Version::RELEASE.should eql(4)
    expect(Amalgalite::SQLite3::Version.to_a.size).to eql(3)

    Amalgalite::SQLite3::Version.compiled_version.should be == "3.39.4"
    Amalgalite::SQLite3::Version.compiled_version_number.should be == 3039004
    Amalgalite::SQLite3::Version.compiled_matches_runtime?.should be == true
  end

  it "should have the sqlite3 source id" do
    source_id = "2022-09-29 15:55:41 a29f9949895322123f7c38fbe94c649a9d6e6c9cd0c3b41c96d694552f26b309"
    Amalgalite::SQLite3::Version.compiled_source_id.should be == source_id
    Amalgalite::SQLite3::Version.runtime_source_id.should be == source_id
  end
end
