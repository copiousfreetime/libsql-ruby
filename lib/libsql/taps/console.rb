#--
# Copyright (c) 2008 Jeremy Hinegardner
# All rights reserved.  See LICENSE and/or COPYING for details.
#++

require 'libsql/taps/io'

module ::Libsql::Taps
  #
  # Class provide an IO tap that can write to $stdout
  #
  class Stdout < ::Libsql::Taps::IO
    def initialize
      super( $stdout )
    end
  end

  #
  # This class provide an IO tap that can write to $stderr
  #
  class Stderr < ::Libsql::Taps::IO
    def initialize
      super( $stderr )
    end
  end

end
