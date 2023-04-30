#--
# Copyright (c) 2023 Jeremy Hinegardner
# All rights reserved.  See LICENSE and/or COPYING for details.
#++
module ::Libsql
  module SQLite3
    module LibsqlVersion
     def self.compiled_matches_runtime?
        self.compiled_version == self.runtime_version
      end
    end

    # Version of libsql that ships with
    LIBSQL_VERSION = LibsqlVersion.to_s.freeze
  end
end

unless ::Libsql::SQLite3::LibsqlVersion.compiled_matches_runtime? then
  warn <<eom
You are seeing something odd.  The compiled version of libsql that
is embedded in this extension is for some reason, not being used.
The version in the extension is #{::Libsql::SQLite3::LibsqlVersion.compiled_version} and the version that
as been loaded as a shared library is #{::Libsql::SQLite3::LibsqlVersion.runtime_version}.  These versions
should be the same, but they are not.

One known issue is if you are using this libary in conjunction with
Hitimes on Mac OS X.  You should make sure that "require 'libsql'"
appears before "require 'hitimes'" in your ruby code.

This is a non-trivial problem, and I am working on it.
eom
end
