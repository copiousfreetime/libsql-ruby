require 'spec_helper'
require 'libsql/version'

describe "::Libsql::VERSION" do
  it "should have a version string" do
    expect(::Libsql::VERSION).to match( /\d+\.\d+\.\d+/ )
  end
end
