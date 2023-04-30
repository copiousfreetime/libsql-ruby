require 'spec_helper'

require 'libsql'
require 'libsql/boolean'

describe ::Libsql::Boolean do
  %w[ True Y Yes T 1 ].each do |v|
    it "converts #{v} to true" do
      ::Libsql::Boolean.to_bool(v).should == true
    end
  end

  %w[ False F f No n 0 ].each do |v|
    it "converts #{v} to false " do
      ::Libsql::Boolean.to_bool(v).should == false
    end
  end

  %w[ other things nil ].each do |v|
    it "converts #{v} to nil" do
      ::Libsql::Boolean.to_bool(v).should == nil
    end
  end
end
