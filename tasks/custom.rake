#-----------------------------------------------------------------------
# Custom tasks for this project
#-----------------------------------------------------------------------
require 'pathname'
namespace :util do
  desc "List the sqlite api calls that are not implemented"
  task :todo do

    not_implementing = %w[
      sqlite3_exec
      sqlite3_open
      sqlite3_os_end
      sqlite3_os_init
      sqlite3_malloc
      sqlite3_realloc
      sqlite3_free
      sqlite3_get_table
      sqlite3_free_table
      sqlite3_key
      sqlite3_rekey
      sqlite3_next_stmt
      sqlite3_release_memory
      sqlite3_sleep
      sqlite3_snprintf
      sqlite3_vmprintf
      sqlite3_strnicmp
      sqlite3_test_control
      sqlite3_unlock_notify
      sqlite3_vfs_find
      sqlite3_vfs_register
      sqlite3_vfs_unregister
    ]

    sqlite_h = File.join( *%w[ ext libsql c sqlite3.h ] )
    api_todo = {}
    IO.readlines( sqlite_h ).each do |line|
      if line =~ /\ASQLITE_API/ then
        if line !~ /SQLITE_DEPRECATED/ and line !~ /SQLITE_EXPERIMENTAL/ then
          if md = line.match( /(sqlite3_[^(\s]+)\(/ ) then
                                next if not_implementing.include?(md.captures[0])
                                api_todo[md.captures[0]] = true
          end
        end
      end
    end

    Dir.glob("ext/libsql/c/libsql*.c").each do |am_file|
      IO.readlines( am_file ).each do |am_line|
        if md = am_line.match( /(sqlite3_[^(\s]+)\(/ ) then
                                 api_todo.delete( md.captures[0] )
        end
      end
    end

    puts "#{api_todo.keys.size} functions to still implement"
    puts api_todo.keys.sort.join("\n")
  end

  desc "Download and integrate the latest version of libsql"
  task :update_libsql, [:version] do |task, args|
    require 'uri'
    require 'open-uri'

    asset_regex = /\Alibsql-amalgamation-(\d+\.\d+\.\d+)\.tar\.gz\Z/

    asset = nil
    require 'debug'

    if args[:version] then
      all_releases_uri = "https://api.github.com/repos/libsql/libsql/releases"
      all_releases_json  = ::URI.parse(all_releases_uri).read
      all_releases_parsed = JSON.parse(all_releases_json)
      version_release = all_releases_parsed.find { |p| p['tag_name'] == "libsql-#{args[:version]}" }
      if version_release then
        assets_url = version_release['assets_url']
        assets_json = ::URI.parse(assets_url).read
        assets_parsed = JSON.parse(assets_json)
        asset = assets_parsed.find { |a| a['name'] =~ asset_regex }
      else
        msg = [
        "Unable to find release for `libsql-#{args[:version]}`. Found releases for:"
        ]
        all_releases_parsed.map{ |p| p['tag_name'] }.each do |tag|
          msg << "  #{tag}"
        end

        abort msg.join("\n")
      end
    else
      latest_uri = "https://api.github.com/repos/libsql/libsql/releases/latest"
      latest_json = ::URI.parse(latest_uri).read
      latest_parsed = JSON.parse(latest_json)
      asset = latest_parsed['assets'].find { |a| a['name'] =~ asset_regex }
    end

    asset_name = asset['name']
    tarball_uri = ::URI.parse(asset['browser_download_url'])
    puts "Downloading from #{tarball_uri}"
    file = "tmp/#{File.basename(tarball_uri.path)}"
    puts "              to #{file}"

    FileUtils.mkdir "tmp" unless File.directory?( "tmp" )
    if File.exist?(file) then
      puts "  #{file} already exists.."
    else
      File.open( file, "wb+") do |f|
        tarball_uri.open do |input|
          f.write( input.read )
        end
      end
    end

    puts "extracting"
    upstream_files = %w[ sqlite3.h sqlite3.c ]

    require 'rubygems'
    # Using the built in rubygems tar reader since we know it exists
    ::Zlib::GzipReader.open(file) do |gz|
      ::Gem::Package::TarReader.new(gz) do |reader|
        reader.each do |entry|
          next unless entry.file?
          bname = File.basename(entry.full_name)
          if upstream_files.include?(bname) then
            dest_path = File.join( "ext", "libsql", "c", bname )
            puts "updating #{dest_path}"
            File.open(dest_path, "w+") do |dest_file|
              dest_file.write(entry.read)
            end
          end
        end
      end
    end
  end
end
