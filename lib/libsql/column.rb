#--
# Copyright (c) 2008 Jeremy Hinegardner
# All rights reserved.  See LICENSE and/or COPYING for details.
#++

require 'libsql/boolean'
require 'libsql/blob'

module ::Libsql
  ##
  # a class representing the meta information about an SQLite column, this class
  # serves both for general Schema level information, and for result set
  # information from a SELECT query.
  #
  class Column
    # the schema object this column is associated with
    attr_accessor :schema

    # the database name this column belongs to. This will be 'main' for the main
    # database, 'temp' for the temp database and whatever an attached database
    # was attached as.
    attr_accessor :db

    # the table to which this column belongs
    attr_accessor :table

    # the column name
    attr_accessor :name

    # the default value of the column.   This may not have a value and that
    # either means that there is no default value, or one could not be
    # determined.
    #
    attr_accessor :default_value

    # the declared data type of the column in the original sql that created the
    # column
    attr_accessor :declared_data_type

    # the collation sequence name of the column
    attr_accessor :collation_sequence_name

    # The index (starting with 0) of this column in the table definition
    # or result set
    attr_accessor :order

    ##
    # Create a column with its name and associated table
    #
    def initialize( db, table, name, order)
      @db                 = db
      @table              = table
      @name               = name
      @order              = Float(order).to_i
      @declared_data_type = nil
      @default_value      = nil
    end

    # true if the column has a default value
    def has_default_value?
      not default_value.nil?
    end

    # true if the column may have a NULL value
    def nullable?
      @not_null_constraint == false
    end

    # set whether or not the column has a not null constraint
    def not_null_constraint=( other )
      @not_null_constraint = Boolean.to_bool( other )
    end

    # true if the column as a NOT NULL constraint
    def not_null_constraint?
      @not_null_constraint
    end

    # set whether or not the column is a primary key column
    def primary_key=( other )
      @primary_key = Boolean.to_bool( other )
    end

    # true if the column is a primary key column
    def primary_key?
      @primary_key
    end

    # set whether or not the column is auto increment
    def auto_increment=( other )
      @auto_increment = Boolean.to_bool( other )
    end

    # true if the column is auto increment
    def auto_increment?
      @auto_increment
    end
  end
end
