#include "libsql_ext.h"
/**
 * Copyright (c) 2008 Jeremy Hinegardner
 * All rights reserved.  See LICENSE and/or COPYING for details.
 *
 * vim: shiftwidth=4 
 */ 

/* class  Amalgliate::SQLite3::Blob */
VALUE cLS_Blob;   

/**
 * call-seq:
 *   Blob.new( database, table_name, column_name, row_id, flag ) -> Blob
 *
 * Create a new Blob object and associate it with the approriate, database,
 * table, column and row.  +flag+ indicates if the Blob is to be opened for
 * writing "w" or reading "r".
 *
 */
VALUE libsql_ext_sqlite3_blob_initialize( VALUE self, VALUE db, VALUE db_name, VALUE table_name, VALUE column_name, VALUE rowid, VALUE flag) 
{
    libsql_ext_sqlite3_blob *libsql_ext_blob;
    int              rc;
    libsql_ext_sqlite3      *libsql_ext_db;
    char            *zDb      = StringValuePtr( db_name );
    char            *zTable   = StringValuePtr( table_name );
    char            *zColumn  = StringValuePtr( column_name );
    sqlite3_int64    iRow     = NUM2SQLINT64( rowid )  ;
    VALUE            flag_str = StringValue( flag );
    int              flags    = 0;

    /* extract the blob struct */
    Data_Get_Struct(self, libsql_ext_sqlite3_blob, libsql_ext_blob);
    
    /* extract the sqlite3 db struct */
    Data_Get_Struct(db, libsql_ext_sqlite3, libsql_ext_db);

    /* make sure that the flags are valid, only 'r' or 'w' are allowed */
    if ( ( RSTRING_LEN( flag_str ) != 1) || 
         ( ( 'r' != RSTRING_PTR( flag_str )[0] ) && 
           ( 'w' != RSTRING_PTR( flag_str )[0] ))) {
        rb_raise( eLS_Error, "Error opening Blob in db = %s, table = %s, column = %s, rowid = %lu.  Invalid flag '%s'.  Must be either 'w' or 'r'\n",
                             zDb, zTable, zColumn, (unsigned long)iRow, RSTRING_PTR( flag_str ));
    }

    /* switch to write mode */
    if ( 'w' == RSTRING_PTR( flag_str )[0] ) { 
        flags = 1;
    }

    /* open the blob and associate the db to it */
    rc = sqlite3_blob_open( libsql_ext_db->db, zDb, zTable, zColumn, iRow, flags, &( libsql_ext_blob->blob ) );
    if ( SQLITE_OK != rc ) {
        rb_raise( eLS_Error, "Error opening Blob in db = %s, table = %s, column = %s, rowid = %lu : [SQLITE_ERROR %d] %s\n", zDb, zTable, zColumn, (unsigned long)iRow, rc, sqlite3_errmsg( libsql_ext_db->db) );  
    }
    libsql_ext_blob->length = sqlite3_blob_bytes( libsql_ext_blob->blob );
    libsql_ext_blob->db = libsql_ext_db->db;

    /* if a block is given then yield self and close the blob when done */
    if ( rb_block_given_p() ) {
        rb_yield( self );
        libsql_ext_sqlite3_blob_close( self );
        return Qnil;
    } else {
        return self;
    }
}

/**
 * call-seq:
 *  blob.close -> nil
 *
 * Closes the blob.
 */
VALUE libsql_ext_sqlite3_blob_close( VALUE self )
{
    libsql_ext_sqlite3_blob *libsql_ext_blob;
    int              rc;
    
    Data_Get_Struct(self, libsql_ext_sqlite3_blob, libsql_ext_blob);
    rc = sqlite3_blob_close( libsql_ext_blob->blob );
    if ( SQLITE_OK != rc ) {
        rb_raise(eLS_Error, "Error closing blob: [SQLITE_ERROR %d] %s\n",
                rc, sqlite3_errmsg( libsql_ext_blob->db ));
    }


    return Qnil;
}


/**
 * call-seq:
 *  blob.length -> length in bytes of the blob
 *
 * Returns the number of bytes in the blob.
 */
VALUE libsql_ext_sqlite3_blob_length( VALUE self )
{
    libsql_ext_sqlite3_blob *libsql_ext_blob;

    Data_Get_Struct(self, libsql_ext_sqlite3_blob, libsql_ext_blob);

    return INT2FIX( libsql_ext_blob->length );
}

/**
 * call-seq:
 *   blob.read( int ) -> String containting int number of  bytes or nil if eof.
 *
 * returns int number of bytes as a String from the database
 */
VALUE libsql_ext_sqlite3_blob_read( VALUE self, VALUE length )
{
    libsql_ext_sqlite3_blob *libsql_ext_blob;
    int             rc;
    int              n = NUM2INT( length );
    void           *buf = NULL;
    VALUE          result;

    Data_Get_Struct(self, libsql_ext_sqlite3_blob, libsql_ext_blob);

    /* we have to be exact on the number of bytes to read.  n + current_offset
     * cannot be larger than the blob's length
     */
    if ( (n + libsql_ext_blob->current_offset > libsql_ext_blob->length)) {
        n = libsql_ext_blob->length - libsql_ext_blob->current_offset;
    }

    if ( libsql_ext_blob->current_offset == libsql_ext_blob->length ) {
        return Qnil;
    }

    buf = (void *)malloc( n );
    rc = sqlite3_blob_read( libsql_ext_blob->blob, buf, n, libsql_ext_blob->current_offset); 

    if ( rc != SQLITE_OK ) {
        rb_raise(eLS_Error, "Error reading %d bytes blob at offset %d: [SQLITE_ERROR %d] %s\n",
                n, libsql_ext_blob->current_offset, rc, sqlite3_errmsg( libsql_ext_blob->db ));
    }

    libsql_ext_blob->current_offset += n;

    result = rb_str_new( (char*)buf, n );
    free( buf );
    return result;

}

/**
 * call-seq:
 *   blob.write( buf ) -> int
 *
 * writes the contents of the string buffer to the blob and returns the number
 * of bytes written.
 *
 */
VALUE libsql_ext_sqlite3_blob_write( VALUE self, VALUE buf )
{
    libsql_ext_sqlite3_blob *libsql_ext_blob;
    int              rc;
    VALUE            str = StringValue( buf );
    int              n   = (int)RSTRING_LEN( str );
    char            *chk_buf = NULL;

    Data_Get_Struct(self, libsql_ext_sqlite3_blob, libsql_ext_blob);

    rc = sqlite3_blob_write( libsql_ext_blob->blob, RSTRING_PTR(str), n, libsql_ext_blob->current_offset); 

    if ( rc  != SQLITE_OK ) {
        rb_raise(eLS_Error, "Error writing %d bytes blob at offset %d: [SQLITE_ERROR %d] %s\n",
                n, libsql_ext_blob->current_offset, rc, sqlite3_errmsg( libsql_ext_blob->db ));
    }

    chk_buf = (char *) malloc( n  + 1);
    chk_buf[n] = '\0';
    sqlite3_blob_read( libsql_ext_blob->blob, chk_buf, n, 0);

    libsql_ext_blob->current_offset += n;

    return INT2FIX( n );

}


/***********************************************************************
 * Ruby life cycle methods
 ***********************************************************************/

/*
 * garbage collector free method for the libsql_ext_sqlite3_blob structure
 */
void libsql_ext_sqlite3_blob_free(libsql_ext_sqlite3_blob* wrapper)
{
    free(wrapper);
    return;
}

/*
 * allocate the libsql_ext_blob structure
 */
VALUE libsql_ext_sqlite3_blob_alloc(VALUE klass)
{
    libsql_ext_sqlite3_blob  *wrapper = ALLOC( libsql_ext_sqlite3_blob );
    VALUE             obj     ; 

    wrapper->current_offset = 0;
    wrapper->db             = NULL;
    obj = Data_Wrap_Struct(klass, NULL, libsql_ext_sqlite3_blob_free, wrapper);
    return obj;
}


/**
 * Document-class: Libsql::SQLite3::Blob
 *
 * The Blob class enables incremental IO on blob items.  If you do not need
 * incremental IO on a binary object, then you do not need to use Blob.
 */

void Init_libsql_ext_blob( )
{

    VALUE ma  = rb_define_module("Libsql");
    VALUE mas = rb_define_module_under(ma, "SQLite3");

    /*
     * Encapsulate the SQLite3 Statement handle in a class
     */
    cLS_Blob = rb_define_class_under( mas, "Blob", rb_cObject ); 
    rb_define_alloc_func(cLS_Blob, libsql_ext_sqlite3_blob_alloc); 
    rb_define_method(cLS_Blob, "initialize", libsql_ext_sqlite3_blob_initialize, 6); 
    rb_define_method(cLS_Blob, "close", libsql_ext_sqlite3_blob_close, 0); 
    rb_define_method(cLS_Blob, "read", libsql_ext_sqlite3_blob_read, 1); 
    rb_define_method(cLS_Blob, "write", libsql_ext_sqlite3_blob_write, 1); 
    rb_define_method(cLS_Blob, "length", libsql_ext_sqlite3_blob_length, 0); 
}


