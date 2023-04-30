/**
 * Copyright (c) 2023 Jeremy Hinegardner
 * All rights reserved.  See LICENSE and/or COPYING for details.
 *
 * vim: shiftwidth=4 
 */ 

#ifndef __LIBSQL_H__
#define __LIBSQL_H__

#include "ruby.h"
#include "sqlite3.h"
#include <string.h>

/* wrapper struct around the sqlite3 opaque pointer */
typedef struct am_sqlite3 {
  sqlite3 *db;
  VALUE    trace_obj;
  VALUE    profile_obj;
  VALUE    busy_handler_obj;
  VALUE    progress_handler_obj;
} am_sqlite3;

/* wrapper struct around the sqlite3_statement opaque pointer */
typedef struct am_sqlite3_stmt {
  sqlite3_stmt *stmt;
  VALUE         remaining_sql;
} am_sqlite3_stmt;

/* wrapper struct around the sqlite3_blob opaque ponter */
typedef struct am_sqlite3_blob {
  sqlite3_blob *blob;
  sqlite3      *db;
  int           length;
  int           current_offset;
} am_sqlite3_blob;

/* wrapper struct around the information needed to call rb_apply
 * used to encapsulate data into a call for amalgalite_wrap_apply
 */
typedef struct am_protected {
    VALUE     instance;
    ID        method;
    int       argc;
    VALUE    *argv;
} am_protected_t;

/** module and classes **/
extern VALUE mA;              /* module Libsql                     */
extern VALUE mAS;             /* module Libsql::SQLite3            */
extern VALUE mASV;            /* module Libsql::SQLite3::Version   */
extern VALUE eAS_Error;       /* class  Libsql::SQLite3::Error     */
extern VALUE cAR;             /* class  Libsql::Requries */
extern VALUE cARB;            /* class  Libsql::Requries::Bootstrap  */

/*----------------------------------------------------------------------
 * Prototype for Libsql::SQLite3::Database
 *---------------------------------------------------------------------*/
extern VALUE cAS_Database;    /* class  Libsql::SQLite3::Database  */

extern void  am_define_constants_under(VALUE);
extern VALUE am_sqlite3_database_alloc(VALUE klass);
extern void  am_sqlite3_database_free(am_sqlite3*);
extern VALUE am_sqlite3_database_open(int argc, VALUE* argv, VALUE self);
extern VALUE am_sqlite3_database_close(VALUE self);
extern VALUE am_sqlite3_database_open16(VALUE self, VALUE rFilename);
extern VALUE am_sqlite3_database_last_insert_rowid(VALUE self);
extern VALUE am_sqlite3_database_is_autocommit(VALUE self);
extern VALUE am_sqlite3_database_row_changes(VALUE self);
extern VALUE am_sqlite3_database_total_changes(VALUE self);
extern VALUE am_sqlite3_database_table_column_metadata(VALUE self, VALUE db_name, VALUE tbl_name, VALUE col_name);

extern VALUE am_sqlite3_database_prepare(VALUE self, VALUE rSQL);
extern VALUE am_sqlite3_database_register_trace_tap(VALUE self, VALUE tap);
extern VALUE am_sqlite3_database_register_profile_tap(VALUE self, VALUE tap);
extern VALUE am_sqlite3_database_busy_handler(VALUE self, VALUE handler);

/*----------------------------------------------------------------------
 * Prototype for Libsql::SQLite3::Statement 
 *---------------------------------------------------------------------*/
extern VALUE cAS_Statement;   /* class  Libsql::SQLite3::Statement */

extern VALUE am_sqlite3_statement_alloc(VALUE klass);
extern void  am_sqlite3_statement_free(am_sqlite3_stmt* );
extern VALUE am_sqlite3_statement_sql(VALUE self);
extern VALUE am_sqlite3_statement_close(VALUE self);
extern VALUE am_sqlite3_statement_step(VALUE self);
extern VALUE am_sqlite3_statement_column_count(VALUE self);
extern VALUE am_sqlite3_statement_column_name(VALUE self, VALUE index);
extern VALUE am_sqlite3_statement_column_decltype(VALUE self, VALUE index);
extern VALUE am_sqlite3_statement_column_type(VALUE self, VALUE index);
extern VALUE am_sqlite3_statement_column_blob(VALUE self, VALUE index);
extern VALUE am_sqlite3_statement_column_text(VALUE self, VALUE index);
extern VALUE am_sqlite3_statement_column_int(VALUE self, VALUE index);
extern VALUE am_sqlite3_statement_column_int64(VALUE self, VALUE index);
extern VALUE am_sqlite3_statement_column_double(VALUE self, VALUE index);

extern VALUE am_sqlite3_statement_column_database_name(VALUE self, VALUE position);
extern VALUE am_sqlite3_statement_column_table_name(VALUE self, VALUE position);
extern VALUE am_sqlite3_statement_column_origin_name(VALUE self, VALUE position);

extern VALUE am_sqlite3_statement_reset(VALUE self);
extern VALUE am_sqlite3_statement_clear_bindings(VALUE self);
extern VALUE am_sqlite3_statement_bind_parameter_count(VALUE self);
extern VALUE am_sqlite3_statement_bind_parameter_index(VALUE self, VALUE parameter_name);
extern VALUE am_sqlite3_statement_remaining_sql(VALUE self);
extern VALUE am_sqlite3_statement_bind_text(VALUE self, VALUE position, VALUE value);
extern VALUE am_sqlite3_statement_bind_blob(VALUE self, VALUE position, VALUE value);
extern VALUE am_sqlite3_statement_bind_zeroblob(VALUE self, VALUE position, VALUE value);
extern VALUE am_sqlite3_statement_bind_int(VALUE self, VALUE position, VALUE value);
extern VALUE am_sqlite3_statement_bind_int64(VALUE self, VALUE position, VALUE value);
extern VALUE am_sqlite3_statement_bind_double(VALUE self, VALUE position, VALUE value);
extern VALUE am_sqlite3_statement_bind_null(VALUE self, VALUE position);

/*----------------------------------------------------------------------
 * Prototype for Libsql::SQLite3::Blob
 *---------------------------------------------------------------------*/
extern VALUE cAS_Blob; /* class Libsql::SQLite3::Blob */

extern VALUE am_sqlite3_blob_alloc(VALUE klass);
extern VALUE am_sqlite3_blob_initialize( VALUE self, VALUE db, VALUE db_name, VALUE table_name, VALUE column_name, VALUE rowid, VALUE flag) ;
extern void  am_sqlite3_blob_free(am_sqlite3_blob* );
extern VALUE am_sqlite3_blob_read(VALUE self, VALUE length);
extern VALUE am_sqlite3_blob_write(VALUE self, VALUE buffer);
extern VALUE am_sqlite3_blob_close(VALUE self);
extern VALUE am_sqlite3_blob_length(VALUE self);

/*----------------------------------------------------------------------
 * more initialization methods
 *----------------------------------------------------------------------*/
extern void Init_amalgalite_constants( );
extern void Init_amalgalite_database( );
extern void Init_amalgalite_statement( );
extern void Init_amalgalite_blob( );

 
/***********************************************************************
 * Type conversion macros between sqlite data types and ruby types
 **********************************************************************/

#define SQLINT64_2NUM(x)      ( LL2NUM( x ) )
#define SQLUINT64_2NUM(x)     ( ULL2NUM( x ) )
#define NUM2SQLINT64( obj )   ( NUM2LL( obj ) )
#define NUM2SQLUINT64( obj )  ( NUM2ULL( obj ) )

/***********************************************************************
 * return the last exception in ruby's error message
 */
#define ERROR_INFO_MESSAGE()  ( rb_obj_as_string( rb_gv_get("$!") ) )
#endif
