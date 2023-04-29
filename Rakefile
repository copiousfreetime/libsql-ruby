# vim: syntax=ruby
load 'tasks/this.rb'

This.name     = "libsql"
This.author   = "Jeremy Hinegardner"
This.email    = "jeremy@copiousfreetime.org"
This.homepage = "http://github.com/copiousfreetime/#{ This.name }-ruby"

This.ruby_gemspec do |spec|
  spec.add_dependency( 'arrayfields', '~> 4.9' )

  spec.add_development_dependency( 'debug',              '~> 1.0' )
  spec.add_development_dependency( 'rspec',              '~> 3.12' )
  spec.add_development_dependency( 'rspec_junit_formatter','~> 0.6' )
  spec.add_development_dependency( 'rake',               '~> 13.0' )
  spec.add_development_dependency( 'rake-compiler',      '~> 1.2'  )
  spec.add_development_dependency( 'rake-compiler-dock', '~> 1.2'  )
  spec.add_development_dependency( 'rdoc',               '~> 6.5'  )
  spec.add_development_dependency( 'simplecov',          '~> 0.21' )
  spec.add_development_dependency( 'archive-zip',        '~> 0.12' )

  spec.extensions.concat This.extension_conf_files
  spec.license = "BSD-3-Clause"
end

load 'tasks/default.rake'
load 'tasks/extension.rake'
load 'tasks/custom.rake'
