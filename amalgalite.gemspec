# DO NOT EDIT - This file is automatically generated
# Make changes to Manifest.txt and/or Rakefile and regenerate
# -*- encoding: utf-8 -*-
# stub: amalgalite 1.7.2 ruby lib
# stub: ext/amalgalite/c/extconf.rb

Gem::Specification.new do |s|
  s.name = "amalgalite".freeze
  s.version = "1.7.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jeremy Hinegardner".freeze]
  s.date = "2022-06-17"
  s.description = "Amalgalite embeds the SQLite database engine as a ruby extension. There is no need to install SQLite separately.".freeze
  s.email = "jeremy@copiousfreetime.org".freeze
  s.executables = ["amalgalite-pack".freeze]
  s.extensions = ["ext/amalgalite/c/extconf.rb".freeze]
  s.extra_rdoc_files = ["CONTRIBUTING.md".freeze, "HISTORY.md".freeze, "Manifest.txt".freeze, "README.md".freeze, "TODO.md".freeze, "ext/amalgalite/c/notes.txt".freeze, "spec/data/iso-3166-country.txt".freeze, "spec/data/iso-3166-subcountry.txt".freeze]
  s.files = ["CONTRIBUTING.md".freeze, "HISTORY.md".freeze, "LICENSE".freeze, "Manifest.txt".freeze, "README.md".freeze, "Rakefile".freeze, "TODO.md".freeze, "bin/amalgalite-pack".freeze, "examples/a.rb".freeze, "examples/blob.rb".freeze, "examples/bootstrap.rb".freeze, "examples/define_aggregate.rb".freeze, "examples/define_function.rb".freeze, "examples/fts5.rb".freeze, "examples/gem-db.rb".freeze, "examples/require_me.rb".freeze, "examples/requires.rb".freeze, "examples/schema-info.rb".freeze, "ext/amalgalite/c/amalgalite.c".freeze, "ext/amalgalite/c/amalgalite.h".freeze, "ext/amalgalite/c/amalgalite_blob.c".freeze, "ext/amalgalite/c/amalgalite_constants.c".freeze, "ext/amalgalite/c/amalgalite_database.c".freeze, "ext/amalgalite/c/amalgalite_requires_bootstrap.c".freeze, "ext/amalgalite/c/amalgalite_statement.c".freeze, "ext/amalgalite/c/extconf.rb".freeze, "ext/amalgalite/c/gen_constants.rb".freeze, "ext/amalgalite/c/notes.txt".freeze, "ext/amalgalite/c/sqlite3.c".freeze, "ext/amalgalite/c/sqlite3.h".freeze, "ext/amalgalite/c/sqlite3_options.h".freeze, "ext/amalgalite/c/sqlite3ext.h".freeze, "lib/amalgalite.rb".freeze, "lib/amalgalite/aggregate.rb".freeze, "lib/amalgalite/blob.rb".freeze, "lib/amalgalite/boolean.rb".freeze, "lib/amalgalite/busy_timeout.rb".freeze, "lib/amalgalite/column.rb".freeze, "lib/amalgalite/core_ext/kernel/require.rb".freeze, "lib/amalgalite/csv_table_importer.rb".freeze, "lib/amalgalite/database.rb".freeze, "lib/amalgalite/function.rb".freeze, "lib/amalgalite/index.rb".freeze, "lib/amalgalite/memory_database.rb".freeze, "lib/amalgalite/packer.rb".freeze, "lib/amalgalite/paths.rb".freeze, "lib/amalgalite/profile_tap.rb".freeze, "lib/amalgalite/progress_handler.rb".freeze, "lib/amalgalite/requires.rb".freeze, "lib/amalgalite/schema.rb".freeze, "lib/amalgalite/sqlite3.rb".freeze, "lib/amalgalite/sqlite3/constants.rb".freeze, "lib/amalgalite/sqlite3/database/function.rb".freeze, "lib/amalgalite/sqlite3/database/status.rb".freeze, "lib/amalgalite/sqlite3/status.rb".freeze, "lib/amalgalite/sqlite3/version.rb".freeze, "lib/amalgalite/statement.rb".freeze, "lib/amalgalite/table.rb".freeze, "lib/amalgalite/taps.rb".freeze, "lib/amalgalite/taps/console.rb".freeze, "lib/amalgalite/taps/io.rb".freeze, "lib/amalgalite/trace_tap.rb".freeze, "lib/amalgalite/type_map.rb".freeze, "lib/amalgalite/type_maps/default_map.rb".freeze, "lib/amalgalite/type_maps/storage_map.rb".freeze, "lib/amalgalite/type_maps/text_map.rb".freeze, "lib/amalgalite/version.rb".freeze, "lib/amalgalite/view.rb".freeze, "spec/aggregate_spec.rb".freeze, "spec/amalgalite_spec.rb".freeze, "spec/blob_spec.rb".freeze, "spec/boolean_spec.rb".freeze, "spec/busy_handler.rb".freeze, "spec/data/iso-3166-country.txt".freeze, "spec/data/iso-3166-schema.sql".freeze, "spec/data/iso-3166-subcountry.txt".freeze, "spec/data/make-iso-db.sh".freeze, "spec/database_spec.rb".freeze, "spec/default_map_spec.rb".freeze, "spec/function_spec.rb".freeze, "spec/integeration_spec.rb".freeze, "spec/iso_3166_database.rb".freeze, "spec/json_spec.rb".freeze, "spec/packer_spec.rb".freeze, "spec/paths_spec.rb".freeze, "spec/progress_handler_spec.rb".freeze, "spec/requires_spec.rb".freeze, "spec/rtree_spec.rb".freeze, "spec/schema_spec.rb".freeze, "spec/spec_helper.rb".freeze, "spec/sqlite3/constants_spec.rb".freeze, "spec/sqlite3/database_status_spec.rb".freeze, "spec/sqlite3/status_spec.rb".freeze, "spec/sqlite3/version_spec.rb".freeze, "spec/sqlite3_spec.rb".freeze, "spec/statement_spec.rb".freeze, "spec/storage_map_spec.rb".freeze, "spec/tap_spec.rb".freeze, "spec/text_map_spec.rb".freeze, "spec/type_map_spec.rb".freeze, "spec/version_spec.rb".freeze, "tasks/custom.rake".freeze, "tasks/default.rake".freeze, "tasks/extension.rake".freeze, "tasks/this.rb".freeze]
  s.homepage = "http://github.com/copiousfreetime/amalgalite".freeze
  s.licenses = ["BSD".freeze]
  s.rdoc_options = ["--main".freeze, "README.md".freeze, "--markup".freeze, "tomdoc".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.2.2".freeze)
  s.rubygems_version = "3.1.6".freeze
  s.summary = "Amalgalite embeds the SQLite database engine as a ruby extension. There is no need to install SQLite separately.".freeze
  s.test_files = ["spec/aggregate_spec.rb".freeze, "spec/amalgalite_spec.rb".freeze, "spec/blob_spec.rb".freeze, "spec/boolean_spec.rb".freeze, "spec/busy_handler.rb".freeze, "spec/data/iso-3166-country.txt".freeze, "spec/data/iso-3166-schema.sql".freeze, "spec/data/iso-3166-subcountry.txt".freeze, "spec/data/make-iso-db.sh".freeze, "spec/database_spec.rb".freeze, "spec/default_map_spec.rb".freeze, "spec/function_spec.rb".freeze, "spec/integeration_spec.rb".freeze, "spec/iso_3166_database.rb".freeze, "spec/json_spec.rb".freeze, "spec/packer_spec.rb".freeze, "spec/paths_spec.rb".freeze, "spec/progress_handler_spec.rb".freeze, "spec/requires_spec.rb".freeze, "spec/rtree_spec.rb".freeze, "spec/schema_spec.rb".freeze, "spec/spec_helper.rb".freeze, "spec/sqlite3/constants_spec.rb".freeze, "spec/sqlite3/database_status_spec.rb".freeze, "spec/sqlite3/status_spec.rb".freeze, "spec/sqlite3/version_spec.rb".freeze, "spec/sqlite3_spec.rb".freeze, "spec/statement_spec.rb".freeze, "spec/storage_map_spec.rb".freeze, "spec/tap_spec.rb".freeze, "spec/text_map_spec.rb".freeze, "spec/type_map_spec.rb".freeze, "spec/version_spec.rb".freeze]

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<arrayfields>.freeze, ["~> 4.9"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.11"])
    s.add_development_dependency(%q<rspec_junit_formatter>.freeze, ["~> 0.5"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_development_dependency(%q<rake-compiler>.freeze, ["~> 1.2"])
    s.add_development_dependency(%q<rake-compiler-dock>.freeze, ["~> 1.2"])
    s.add_development_dependency(%q<rdoc>.freeze, ["~> 6.4"])
    s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.21"])
    s.add_development_dependency(%q<zip>.freeze, ["~> 2.0"])
  else
    s.add_dependency(%q<arrayfields>.freeze, ["~> 4.9"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.11"])
    s.add_dependency(%q<rspec_junit_formatter>.freeze, ["~> 0.5"])
    s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_dependency(%q<rake-compiler>.freeze, ["~> 1.2"])
    s.add_dependency(%q<rake-compiler-dock>.freeze, ["~> 1.2"])
    s.add_dependency(%q<rdoc>.freeze, ["~> 6.4"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.21"])
    s.add_dependency(%q<zip>.freeze, ["~> 2.0"])
  end
end
