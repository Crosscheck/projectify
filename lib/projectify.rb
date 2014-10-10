require 'fileutils'
require 'net/http'
require 'openssl'
require 'uri'
require 'colorize'

class Projectify
  def self.create_dir_drupal(directory)
    output = `didify #{directory}`
    if output.include? "didified"
      return true
    else
      return false
    end
  end

  def self.create_dir_default(directory)
    output = `capify #{directory}`
    if output.include? "capified"
      return true
    else
      return false
    end
  end

  def self.create_structure(value)
    if Dir.mkdir(value)
      output = `cd #{value};touch readme.md`
      return true
    else
      return false
    end
  end

    def self.get_data(url,type)
        if type == "git"

            uri_data = URI.parse("https://raw.githubusercontent.com/Crosscheck/projectify/extra-files/#{url}")
            http_data = Net::HTTP.new(uri_data.host, uri_data.port)
            http_data.use_ssl = true
            http_data.verify_mode = OpenSSL::SSL::VERIFY_NONE
            request_data = Net::HTTP::Get.new(uri_data.request_uri)
            response_data = http_data.request(request_data)

            return response_data.body
        else
            if url.include? "http:"
                uri_data = URI.parse(url)
                http_data = Net::HTTP.new(uri_data.host, uri_data.port)
                response_data = http_data.request(request_data)

                return response_data.body
            else
                puts "Your url must be correctly defined."
                exit
            end
        end
    end


    def self.create_script_directories(directory)
        begin
            if !Dir.exist? directory + "scripts"
                Dir.mkdir(directory + "scripts")
            end
            if !Dir.exist? directory + "varnish"
                Dir.mkdir(directory + "varnish")
            end
            if !Dir.exist? directory + "vendor"
                Dir.mkdir(directory + "vendor")
            end

            return true
        rescue
           puts "Couldn't create one or more of the following directories: scripts, varnish, vendor".red

            return false
        end
    end

    def self.create_script_files(directory)
        if Dir.exist? directory + "scripts"
            script_file = File.new(directory + "scripts/setup.sh", "w")
            script_file.puts(get_data("setup.sh", "git"))
            script_file.close

            sync_file = File.new(directory + "scripts/sync.sh", "w")
            sync_file.puts(get_data("sync.sh", "git"))
            sync_file.close

            update_file = File.new(directory + "scripts/update.sh", "w")
            update_file.puts(get_data("update.sh", "git"))
            update_file.close

            policy_drush = File.new(directory + "scripts/policy.drush.inc", "w")
            policy_drush.puts(get_data("policy.drush.inc", "git"))
            policy_drush.close

            drush_alias = File.new(directory + "scripts/PROJECT_NAME.aliases.drushrc.php", "w")
            drush_alias.puts(get_data("PROJECT_NAME.aliases.drushrc.php", "git"))
            drush_alias.close

            project_make = File.new(directory + "scripts/PROJECT_NAME.make", "w")
            project_make.puts(get_data("PROJECT_NAME.make", "git"))
            project_make.close

            return true
        else
            puts "Could not create the necessary script files.".red

            return false
        end

    end
    def self.create_varnish_files(directory)
        if Dir.exist? directory + "varnish"
            varnish_file = File.new(directory + "varnish/example.vcl", "w")
            varnish_file.puts(get_data("example.vcl", "git"))
            varnish_file.close

            return true
        else
            puts "Could not create the necessary varnish files.".red

            return false
        end
    end

    def self.create_gem_files(directory)
        if Dir.exist? directory
            gem_file = File.new(directory + "Gemfile", "w")
            gem_file.puts(get_data("Gemfile", "git"))
            gem_file.close

            gem_lock_file = File.new(directory + "Gemfile.lock", "w")
            gem_lock_file.puts(get_data("Gemfile.lock", "git"))
            gem_lock_file.close

            return true
        else
            puts "Could not create the necessary gem files.".red

            return false
        end
    end

    def self.create_npm_files(directory)
        if Dir.exist? directory
            npm_file = File.new(directory + "package.json", "w")
            npm_file.puts(get_data("package.json", "git"))
            npm_file.close

            return true
        else
            puts "Could not create the necessary files for nodejs.".red

            return false
        end
    end
end
