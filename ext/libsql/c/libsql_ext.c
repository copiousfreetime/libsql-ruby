/**
 * Copyright (c) 2008 Jeremy Hinegardner
 * All rights reserved.  See LICENSE and/or COPYING for details.
 *
 * vim: shiftwidth=4 
:*/ 

#include "libsql_ext.h"

/* Module and Classes */
VALUE mL;              /* module Libsql                     */
VALUE mLS;             /* module Libsql::SQLite3            */
VALUE mLSV;            /* module Libsql::SQLite3::Version   */
VALUE mLSLibsqlVersion;/* module Libsql::SQLite3::LibsqlVersion   */
VALUE eLS_Error;       /* class  Libsql::SQLite3::Error     */
VALUE cLS_Stat;        /* class  Libsql::SQLite3::Stat      */

/*----------------------------------------------------------------------
 * module methods for Libsql::SQLite3
 *---------------------------------------------------------------------*/

/*
 * call-seq:
 *    Libsql::SQLite3.threadsafe? -> true or false
 *
 * Has the SQLite3 extension been compiled "threadsafe".  If threadsafe? is
 * true then the internal SQLite mutexes are enabled and SQLite is threadsafe.
 * That is threadsafe within the context of 'C' threads.
 *
 */
VALUE libsql_ext_sqlite3_threadsafe(VALUE self)
{
    if (sqlite3_threadsafe()) {
        return Qtrue;
    } else {
        return Qfalse;
    }
}

/*
 * call-seq:
 *  Libsql::SQLite.temp_directory -> String or nil
 *
 * Return the directory name that all that all the temporary files created by
 * SQLite creates will be placed.  If _nil_ is returned, then SQLite will search
 * for an appropriate directory.
 */
VALUE libsql_ext_sqlite3_get_temp_directory( VALUE self )
{
    if (NULL == sqlite3_temp_directory) {
        return Qnil;
    } else {
        return rb_str_new2( sqlite3_temp_directory );
    }
}

/*
 * call-seq:
 *  Libsql::SQLite.temp_directory = "/tmp/location"
 *
 * Set the temporary directory used by sqlite to store temporary directories.
 * It is not safe to set this value after a Database has been opened.
 *
 */
VALUE libsql_ext_sqlite3_set_temp_directory( VALUE self, VALUE new_dir )
{
    char *p   = NULL ;

    if ( NULL != sqlite3_temp_directory ) {
        free( sqlite3_temp_directory );
    }

    if ( Qnil != new_dir ) {
        VALUE str = StringValue( new_dir );

        p = calloc( RSTRING_LEN(str) + 1, sizeof(char) );
        strncpy( p, RSTRING_PTR(str), RSTRING_LEN(str) );
    }

    sqlite3_temp_directory = p;

    return Qnil;
}

VALUE libsql_ext_format_string( const char* pattern, VALUE string )
{
    VALUE to_s= rb_funcall( string, rb_intern("to_s"), 0 );
    VALUE str = StringValue( to_s );
    char *p   = sqlite3_mprintf(pattern, RSTRING_PTR(str));
    VALUE rv  = Qnil;
    if ( NULL != p ) {
        rv  = rb_str_new2( p );
        sqlite3_free( p );
    } else {
        rb_raise( rb_eNoMemError, "Unable to quote string" );
    } 

    return rv;
}
/*
 * call-seq:
 *  Libsql::SQLite.escape( string ) => escaped_string
 *
 * Takes the input string and escapes each ' (single quote) character by
 * doubling it.
 */
VALUE libsql_ext_sqlite3_escape( VALUE self, VALUE string )
{ 
    return ( Qnil == string ) ? Qnil : libsql_ext_format_string( "%q", string );
}

/*
 * call-seq:
 *  Libsql::SQLite.quote( string ) => quoted-escaped string
 *
 * Takes the input string and surrounds it with single quotes, it also escapes
 * each embedded single quote with double quotes.
 */
VALUE libsql_ext_sqlite3_quote( VALUE self, VALUE string )
{
    return ( Qnil == string ) ? Qnil : libsql_ext_format_string( "%Q", string );
}

/*
 * call-seq:
 *    Libsql::SQLite3.complete?( ... , opts = { :utf16 => false }) -> True, False
 *
 * Is the text passed in as a parameter a complete SQL statement?  Or is
 * additional input required before sending the SQL to the extension.  If the
 * extra 'opts' parameter is used, you can send in a UTF-16 encoded string as
 * the SQL.
 *
 * A complete statement must end with a semicolon.
 *
 */
VALUE libsql_ext_sqlite3_complete(VALUE self, VALUE args)
{
    VALUE sql      = rb_ary_shift( args );
    VALUE opts     = rb_ary_shift( args );
    VALUE utf16    = Qnil;
    int   result = 0;

    if ( ( Qnil != opts ) && ( T_HASH == TYPE(opts) ) ){
        utf16 = rb_hash_aref( opts, rb_intern("utf16") );
    }

    if ( (Qfalse == utf16) || (Qnil == utf16) ) {
        result = sqlite3_complete( StringValuePtr( sql ) );
    } else {
        result = sqlite3_complete16( (void*) StringValuePtr( sql ) );
    }

    return ( result > 0 ) ? Qtrue : Qfalse;
}

/*
 * call-seq:
 *    Libsql::SQLite3::Stat.update!( reset = false ) -> nil
 *
 * Populates the _@current_ and _@higwater_ instance variables of self
 * object with the values from the sqlite3_status call.  If reset it true then
 * the highwater mark for the stat is reset
 *
 */
VALUE libsql_ext_sqlite3_stat_update_bang( int argc, VALUE *argv, VALUE self )
{
    int status_op  = -1;
    int current    = -1;
    int highwater  = -1;
    VALUE reset    = Qfalse;
    int reset_flag = 0;
    int rc;

    status_op  = FIX2INT( rb_iv_get( self, "@code" ) );
    if ( argc > 0 ) {
        reset = argv[0];
        reset_flag = ( Qtrue == reset ) ? 1 : 0 ;
    }

    rc = sqlite3_status( status_op, &current, &highwater, reset_flag );

    if ( SQLITE_OK != rc ) {
        VALUE n    = rb_iv_get( self,  "@name" ) ;
        char* name = StringValuePtr( n );
        rb_raise(eLS_Error, "Failure to retrieve status for %s : [SQLITE_ERROR %d] \n", name, rc);
    }

    rb_iv_set( self, "@current", INT2NUM( current ) );
    rb_iv_set( self, "@highwater", INT2NUM( highwater) );

    return Qnil;
}

/*
 * call-seq:
 *    Libsql::SQLite3.randomness( N ) -> String of length N
 *
 * Generate N bytes of random data.
 *
 */
VALUE libsql_ext_sqlite3_randomness(VALUE self, VALUE num_bytes)
{
    int n     = NUM2INT(num_bytes);
    char *buf = ALLOCA_N(char, n);

    sqlite3_randomness( n, buf );
    return rb_str_new( buf, n );
}

/*----------------------------------------------------------------------
 * module methods for Libsql::SQLite3::Version
 *---------------------------------------------------------------------*/

/*
 * call-seq:
 *    Libsql::SQLite3::Version.to_s -> String
 *
 * Return the SQLite C library version number as a string
 *
 */
VALUE libsql_ext_sqlite3_runtime_version(VALUE self)
{
    return rb_str_new2(sqlite3_libversion());
}

/*
 * call-seq:
 *    Libsql::SQLite3.Version.to_i -> Fixnum
 *
 * Return the SQLite C library version number as an integer
 *
 */
VALUE libsql_ext_sqlite3_runtime_version_number(VALUE self)
{
    return INT2FIX(sqlite3_libversion_number());
}

/*
 * call-seq:
 *    Libsql::SQLite3::Version.runtime_source_id -> String
 *
 * Return the SQLite C library source id as a string
 *
 */
VALUE libsql_ext_sqlite3_runtime_source_id(VALUE self)
{
    return rb_str_new2(sqlite3_sourceid());
}

/*
 * call-seq:
 *   Libsql::SQLite::Version.compiled_version -> String
 *
 * Return the compiletime version number as a string.
 *
 */
VALUE libsql_ext_sqlite3_compiled_version(VALUE self)
{
    return rb_str_new2( SQLITE_VERSION );
}

/*
 * call-seql:
 *   Libsql::SQLite::Version.compiled_version_number -> Fixnum
 *
 * Return the compiletime library version from the 
 * embedded version of sqlite3.
 *
 */
VALUE libsql_ext_sqlite3_compiled_version_number( VALUE self )
{
    return INT2FIX( SQLITE_VERSION_NUMBER );
}

/*
 * call-seq:
 *    Libsql::SQLite3::Version.compiled_source_id -> String
 *
 * Return the compiled SQLite C library source id as a string
 *
 */
VALUE libsql_ext_sqlite3_compiled_source_id(VALUE self)
{
    return rb_str_new2( SQLITE_SOURCE_ID );
}

/*
 * call-seq:
 *    Libsql::SQLite3::LibsqlVersion.compiled_version -> String
 *
 * Return the compiled SQLite C library source libsql_version as a string
 *
 */
VALUE libsql_ext_sqlite3_libsql_compiled_version(VALUE self) {
    return rb_str_new2( LIBSQL_VERSION );
}

/*
 * call-seq:
 *    Libsql::SQLite3::LibsqlVersion.to_s -> String
 *
 * Return the runtime SQLite C library source libsql_version as a string
 *
 */
VALUE libsql_ext_sqlite3_libsql_runtime_version(VALUE self) {
    return rb_str_new2( libsql_libversion() );
}


/**
 * Document-class: Libsql::SQLite3
 *
 * The SQLite ruby extension inside Libsql.
 *
 */

void Init_libsql_ext()
{
    int rc = 0;

    /*
     * top level module encapsulating the entire Libsql library
     */
    mL   = rb_define_module("Libsql");

    mLS  = rb_define_module_under(mL, "SQLite3");
    rb_define_module_function(mLS, "threadsafe?", libsql_ext_sqlite3_threadsafe, 0);
    rb_define_module_function(mLS, "complete?", libsql_ext_sqlite3_complete, -2);
    rb_define_module_function(mLS, "randomness", libsql_ext_sqlite3_randomness,1);
    rb_define_module_function(mLS, "temp_directory", libsql_ext_sqlite3_get_temp_directory, 0);
    rb_define_module_function(mLS, "temp_directory=", libsql_ext_sqlite3_set_temp_directory, 1);

    rb_define_module_function(mLS, "escape", libsql_ext_sqlite3_escape, 1);
    rb_define_module_function(mLS, "quote", libsql_ext_sqlite3_quote, 1);

    /*
     * class encapsulating a single Stat
     */
    cLS_Stat = rb_define_class_under(mLS, "Stat", rb_cObject);
    rb_define_method(cLS_Stat, "update!", libsql_ext_sqlite3_stat_update_bang, -1);

    /* 
     * Base class of all SQLite3 errors
     */
    eLS_Error = rb_define_class_under(mLS, "Error", rb_eStandardError); /* in libsql_ext.c */

    /**
     * Encapsulation of the SQLite C library version
     */
    mLSV = rb_define_module_under(mLS, "Version");
    rb_define_module_function(mLSV, "to_s", libsql_ext_sqlite3_runtime_version, 0); /* in libsql_ext.c */
    rb_define_module_function(mLSV, "runtime_version", libsql_ext_sqlite3_runtime_version, 0); /* in libsql_ext.c */
    rb_define_module_function(mLSV, "to_i", libsql_ext_sqlite3_runtime_version_number, 0); /* in libsql_ext.c */
    rb_define_module_function(mLSV, "runtime_version_number", libsql_ext_sqlite3_runtime_version_number, 0); /* in libsql_ext.c */
    rb_define_module_function(mLSV, "compiled_version", libsql_ext_sqlite3_compiled_version, 0 ); /* in libsql_ext.c */
    rb_define_module_function(mLSV, "compiled_version_number", libsql_ext_sqlite3_compiled_version_number, 0 ); /* in libsql_ext.c */
    rb_define_module_function(mLSV, "runtime_source_id", libsql_ext_sqlite3_runtime_source_id, 0); /* in libsql_ext.c */
    rb_define_module_function(mLSV, "compiled_source_id", libsql_ext_sqlite3_compiled_source_id, 0); /* in libsql_ext.c */

    mLSLibsqlVersion = rb_define_module_under(mLS, "LibsqlVersion");
    rb_define_module_function(mLSLibsqlVersion, "to_s", libsql_ext_sqlite3_libsql_runtime_version, 0); /* in libsql_ext.c */
    rb_define_module_function(mLSLibsqlVersion, "runtime_version", libsql_ext_sqlite3_libsql_runtime_version, 0 ); /* in libsql_ext.c */
    rb_define_module_function(mLSLibsqlVersion, "compiled_version", libsql_ext_sqlite3_libsql_compiled_version, 0 ); /* in libsql_ext.c */

    /*
     * Initialize the rest of the module
     */
    Init_libsql_ext_constants( );
    Init_libsql_ext_database( );
    Init_libsql_ext_statement( );
    Init_libsql_ext_blob( );

    /*
     * initialize sqlite itself
     */
    rc = sqlite3_initialize();
    if ( SQLITE_OK != rc ) {
        rb_raise(eLS_Error, "Failure to initialize the sqlite3 library : [SQLITE_ERROR %d]\n", rc);
    }

 }


