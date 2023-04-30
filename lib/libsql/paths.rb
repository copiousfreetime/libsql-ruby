#--
# Copyright (c) 2023 Jeremy Hinegardner
# All rights reserved.  See LICENSE and/or COPYING for details.
#++
module ::Libsql
  #
  # Paths contains helpful methods to determine paths of files inside the
  # ::Libsql library
  #
  module Paths
    #
    # The root directory of the project is considered to be the parent directory
    # of the 'lib' directory.
    #
    # returns:: [String] The full expanded path of the parent directory of 'lib'
    #           going up the path from the current file.  Trailing
    #           File::SEPARATOR is guaranteed.
    #
    def self.root_dir
      @root_dir ||= (
        path_parts = ::File.expand_path(__FILE__).split(::File::SEPARATOR)
        lib_index  = path_parts.rindex("lib")
        path_parts[0...lib_index].join(::File::SEPARATOR) + ::File::SEPARATOR
      )
      return @root_dir
    end

    # returns:: [String] The full expanded path of the +config+ directory
    #           below _root_dir_.  All parameters passed in are joined onto the
    #           result.  Trailing File::SEPARATOR is guaranteed if _args_ are
    #           *not* present.
    #
    def self.config_path(*args)
      self.sub_path("config", *args)
    end

    # returns:: [String] The full expanded path of the +data+ directory below
    #           _root_dir_.  All parameters passed in are joined onto the
    #           result. Trailing File::SEPARATOR is guaranteed if
    #           _*args_ are *not* present.
    #
    def self.data_path(*args)
      self.sub_path("data", *args)
    end

    # returns:: [String] The full expanded path of the +lib+ directory below
    #           _root_dir_.  All parameters passed in are joined onto the
    #           result. Trailing File::SEPARATOR is guaranteed if
    #           _*args_ are *not* present.
    #
    def self.lib_path(*args)
      self.sub_path("lib", *args)
    end

    # returns:: [String] The full expanded path of the +ext+ directory below
    #           _root_dir_.  All parameters passed in are joined onto the
    #           result. Trailing File::SEPARATOR is guaranteed if
    #           _*args_ are *not* present.
    #
    def self.ext_path(*args)
      self.sub_path("ext", *args)
    end

    # returns:: [String] The full expanded path of the +spec+ directory below
    #           _root_dir_.  All parameters passed in are joined onto the
    #           result. Trailing File::SEPARATOR is guaranteed if
    #           _*args_ are *not* present.
    #
    def self.spec_path(*args)
      self.sub_path("spec", *args)
    end


    def self.sub_path(sub,*args)
      sp = ::File.join(root_dir, sub) + File::SEPARATOR
      sp = ::File.join(sp, *args) if args
    end
  end
end

