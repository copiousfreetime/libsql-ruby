#--
# Copyright (c) 2008 Jeremy Hinegardner
# All rights reserved.  See LICENSE and/or COPYING for details.
#++
#

module ::Libsql::TypeMaps
  ##
  # An Amalagliate TypeMap that converts both bind parameters and result
  # parameters to a String, no matter what.
  #
  class TextMap < ::Libsql::TypeMap
    def bind_type_of( obj )
      return ::Libsql::SQLite3::Constants::DataType::TEXT
    end

    def result_value_of( delcared_type, value )
      return value.to_s
    end
  end
end
