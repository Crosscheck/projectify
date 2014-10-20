require 'fileutils'
require 'net/http'
require 'openssl'
require 'uri'
require 'colorize'

class Projectify
  def self.create_dir_drupal(directory)
    ###################
    #
    # This function "didify's" a directory so it can be used to deploy a drupal installation with capistrano
    #
    # Didify is an extension for capistrano that specifically targets drupal installations.
    #
    ###################
      puts directory
    output = `didify #{directory}`
    if output.include? 'didified'
      return true
    else
      return false
    end
  end

  def self.create_dir_default(directory)
    ###################
    #
    # This function "capifies" a directory so it can be used to deploy a drupal installation with capistrano
    #
    # Capistrano is a gem that you can use to automate deploys to your servers. (in combination with jenkins or manually)
    #
    ###################
    output = `capify #{directory}`
    if output.include? 'capified'
      return true
    else
      return false
    end
  end

  def self.create_structure(value)
    ###################
    #
    # This function allows you to add a directory to your repository
    #
    #
    #
    ###################
    if Dir.mkdir(value)
      output = `cd #{value};touch readme.md`
      return true
    else
      return false
    end
  end

    def self.exchange_data(file_contents, parameters)
      ###################
      #
      # This function filters the incoming file_contents data and replaces token names with the values that you can find in the parameters hash.
      #
      # file_contents: string
      # parameters: Hash
      #
      ###################
      content_data = ''

      if file_contents.include? 'PROJECT_NAME'
        file_contents.gsub!(/PROJECT_NAME/, parameters[:project_name])
      end

      if file_contents.include? 'SITE_NAME'
        file_contents.gsub!(/SITE_NAME/, parameters[:site_name])
      end

      if file_contents.include? 'SITE_HOST'
        file_contents.gsub!(/SITE_HOST/,parameters[:site_host])
      end

      content_data = file_contents

      return content_data
    end

    def self.exchange_names(file_name, parameters)
      ###################
      #
      # This function filters the incoming file_name and replaces token names with the values that you can find in the parameters hash.
      #
      # file_name: string
      # parameters: Hash
      #
      ###################
      file_name_data = ''
      if file_name.include? 'PROJECT_NAME'
        file_name['PROJECT_NAME'] = parameters[:project_name]
      end

      if file_name.include? 'SITE_NAME'
        file_name['SITE_NAME'] = parameters[:site_name]
      end

      if file_name.include? 'SITE_HOST'
        file_name['SITE_HOST'] = parameters[:site_host]
      end

      file_name_data = file_name

      return file_name_data
    end

    def self.get_data(url,type, parameters)
      ###################
      #
      # This function will retrieve the extra files from a given repository (hardcoded for now)
      # During this function the data of the files will be manipulated with the given parameters
      #
      # url: string, contains the git repository name or a full url (only if type != git)
      # type: string, contains the type of data repository. git or something else
      # parameters: Hash
      #
      ###################
        if type == 'git'
            uri_data = URI.parse("https://raw.githubusercontent.com/Crosscheck/projectify-extra-files/master/#{url}")
            http_data = Net::HTTP.new(uri_data.host, uri_data.port)
            http_data.use_ssl = true
            http_data.verify_mode = OpenSSL::SSL::VERIFY_NONE
            request_data = Net::HTTP::Get.new(uri_data.request_uri)
            response_data = http_data.request(request_data)

            return Projectify.exchange_data(response_data.body, parameters)
        else
            if url.include? 'http:'
                uri_data = URI.parse(url)
                http_data = Net::HTTP.new(uri_data.host, uri_data.port)
                response_data = http_data.request(request_data)

                return Projectify.exchange_data(response_data.body, parameters)
            else
                puts 'Your url must be correctly defined.'
                exit
            end
        end
    end


    def self.create_script_directories(directory)
      ###################
      #
      # This function will create the necessary base directories for the extra files.
      #
      # directory: string
      #
      ###################
        begin
            if !Dir.exist? directory + 'scripts'
                Dir.mkdir(directory + 'scripts')
            end
            if !Dir.exist? directory + 'varnish'
                Dir.mkdir(directory + 'varnish')
            end
            if !Dir.exist? directory + 'vendor'
                Dir.mkdir(directory + 'vendor')
            end

            return true
        rescue
           puts 'Couldn\'t create one or more of the following directories: scripts, varnish, vendor'.red

            return false
        end
    end

    def self.create_script_files(directory, parameters)
      ###################
      #
      # This function will get all seperate generic files with the get_data(url, type, parameters) function
      #
      # directory: string, where to place the file
      # parameters: Hash
      #
      ###################
        if Dir.exist? directory + 'scripts'
            script_file = File.new(directory + 'scripts/' + self.exchange_names('setup.sh', parameters), 'w')
            script_file.puts(get_data('setup.sh', 'git', parameters))
            script_file.close

            sync_file = File.new(directory + 'scripts/' + self.exchange_names('sync.sh', parameters), 'w')
            sync_file.puts(get_data('sync.sh', 'git', parameters))
            sync_file.close

            update_file = File.new(directory + 'scripts/' + self.exchange_names('update.sh', parameters), 'w')
            update_file.puts(get_data('update.sh', 'git', parameters))
            update_file.close

            policy_drush = File.new(directory + 'scripts/' + self.exchange_names('policy.drush.inc', parameters), 'w')
            policy_drush.puts(get_data('policy.drush.inc', 'git', parameters))
            policy_drush.close

            drush_alias = File.new(directory + 'scripts/' + self.exchange_names('PROJECT_NAME.aliases.drushrc.php', parameters), 'w')
            drush_alias.puts(get_data('PROJECT_NAME.aliases.drushrc.php', 'git', parameters))
            drush_alias.close

            project_make = File.new(directory + 'scripts/' + self.exchange_names('PROJECT_NAME.make', parameters), 'w')
            project_make.puts(get_data('PROJECT_NAME.make', 'git', parameters))
            project_make.close

            return true
        else
            puts 'Could not create the necessary script files.'.red

            return false
        end

    end
    def self.create_varnish_files(directory, parameters)
      ###################
      #
      # This function will get all seperate varnish files with the get_data(url, type, parameters) function
      #
      # directory: string, where to place the file
      # parameters: Hash
      #
      ###################
        if Dir.exist? directory + 'varnish'
            varnish_file = File.new(directory + 'varnish/' + self.exchange_names('EXAMPLE.vcl', parameters), 'w')
            varnish_file.puts(get_data('example.vcl', 'git', parameters))
            varnish_file.close

            return true
        else
            puts 'Could not create the necessary varnish files.'.red

            return false
        end
    end

    def self.create_gem_files(directory, parameters)
      ###################
      #
      # This function will get all seperate gem files with the get_data(url, type, parameters) function
      #
      # directory: string, where to place the file
      # parameters: Hash
      #
      ###################
        if Dir.exist? directory
            gem_file = File.new(directory + self.exchange_names('Gemfile', parameters), 'w')
            gem_file.puts(get_data('Gemfile', 'git', parameters))
            gem_file.close

            gem_lock_file = File.new(directory + self.exchange_names('Gemfile.lock', parameters), 'w')
            gem_lock_file.puts(get_data('Gemfile.lock', 'git', parameters))
            gem_lock_file.close

            return true
        else
            puts 'Could not create the necessary gem files.'.red

            return false
        end
    end

    def self.create_npm_files(directory, parameters)
      ###################
      #
      # This function will get all seperate nodejs files with the get_data(url, type, parameters) function
      #
      # directory: string, where to place the file
      # parameters: Hash
      #
      ###################
        if Dir.exist? directory
            npm_file = File.new(directory + self.exchange_names('package.json', parameters), 'w')
            npm_file.puts(get_data('package.json', 'git', parameters))
            npm_file.close

            return true
        else
            puts 'Could not create the necessary files for nodejs.'.red

            return false
        end
    end

    def self.create_vagrant_files(directory, parameters, url)
      if Dir.exist? directory
        output_vagrant = `cd #{directory}/vagrant/; git clone #{url} .`
        if $?.success?
          puts 'Success'.green
        else
          puts 'Error'.red
          puts output_vagrant
        end
      end
    end

end
