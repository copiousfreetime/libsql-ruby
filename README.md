## libsql

[![Build Status](https://copiousfreetime.semaphoreci.com/badges/libsql-ruby/branches/main.svg)](https://copiousfreetime.semaphoreci.com/projects/libsql-ruby)

* [Homepage](http://github.com/copiousfreetime/libsql-ruby)
* `git clone git://github.com/copiousfreetime/libsql-ruby.git`
* [Github](http://github.com/copiousfreetime/libsql-ruby/)
* [Bug Tracking](http://github.com/copiousfreetime/libsql-ruby/issues)

## INSTALL

* `gem install libsql`
* `bundle add libsql`

## DESCRIPTION

libsql embeds the libsql fork of the SQLite database engine as a ruby extension.
There is no need to install libsql separately.

Look in the examples/ directory to see

* general usage
* blob io
* schema information
* custom functions
* custom aggregates
* requiring ruby code from a database
* full text search

Also scroll through Libsql::Database for a quick example, and a general
overview of the API.

libsql adds in the following additional non-default SQLite extensions:

* [R*Tree index extension](http://sqlite.org/rtree.html)
* [Full Text Search](http://sqlite.org/fts5.html) - both fts3 and fts5
* [Geopoly Interface to R*Tree](https://www.sqlite.org/geopoly.html)
* [JSON Extension](https://www.sqlite.org/json1.html)

Other extensions are add that might not be usable/visible by users of the gem.
The full list of extensions added is in
[extconf.rb](ext/libsql/c/extconf.rb). And those may be cross referenced
against the [compile options from SQLite](https://www.sqlite.org/compile.html)

## CREDITS

* This is a straight port of the [amalgalite](https://github.com/copiousfreetime/amalgalite) gem, also written by me.

## CHANGES

Read the [HISTORY.md](HISTORY.md) file.

## LICENSE

Copyright (c) 2023 Jeremy Hinegardner

All rights reserved.

See LICENSE and/or COPYING for details.
