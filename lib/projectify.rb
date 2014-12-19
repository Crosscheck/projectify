require 'fileutils'
require 'net/http'
require 'openssl'
require 'uri'
require 'colorize'
require 'logging'

class Projectify
  def initialize(debug_value, parameters, path)
    debugs = debug_value
    @logs = Logging.new(debugs)
    # The parameters passed to projectify.
    @parameters = parameters
    # The path to build the project in.
    @path = path
    # The path to temporarily store the extra files in.
    @extra_files = 'extra-files'
  end
  ###############
  #
  # Sets up deployment files.
  #
  ###############
  def setup_deploy(type)
    result = false
    if type == "drupal"
      output = `didify #{@path}`
      result = output.include? 'didified'
    else
      output = `capify #{@path}`
      result = output.include? 'capified'
    end

    return result
  end

  def create_structure(value)
    ###################
    #
    # This function allows you to add a directory to your repository
    #
    #
    #
    ###################
    if FileUtils.mkdir_p(value)
      output = `cd #{value};touch readme.md`
      return true
    else
      return false
    end
  end

  def fetch_projectify_extra_files_skeleton(repository)
    target_path = "#{@path}/#{@extra_files}"
    output = `cd #{@path} && git clone #{repository} --branch=master #{@extra_files}`
    @logs.Debug(output)
    FileUtils.rm_rf("#{target_path}/.git");

    self.parse_files(target_path)
    self.merge_files(target_path, @path)
    FileUtils.rm_rf(target_path);
  end

  def replace_placeholders(data)
    new_data = data.clone
    new_data.gsub!(/PROJECT_NAME/, @parameters[:project_name])
    new_data.gsub!(/SITE_NAME/, @parameters[:site_name])
    new_data.gsub!(/SITE_HOST/, @parameters[:site_host])
    return new_data;
  end

  # Replaces file contents and names with the placeholders.
  def parse_files(parse_path)
    self.get_tree(parse_path).sort.each do |entry|
      renamed_entry = self.replace_placeholders(entry)
      File.rename(entry, renamed_entry)

      if File.file?(renamed_entry)
        data = self.replace_placeholders(File.read(renamed_entry))
        File.open(renamed_entry, "w") {|file| file.puts data }
      else
        # Handle subdirectories recursively.
        self.parse_files(renamed_entry)
      end
    end
  end

  def merge_files(from, to)
    FileUtils.mv self.get_tree(from), to, :force => true
  end

  def get_tree(dir)
    return Dir.glob("#{dir}/*", File::FNM_DOTMATCH) - ["#{dir}/.", "#{dir}/.."]
  end

  def create_vagrant_files(directory, parameters, url)
    if Dir.exist? directory
      output_vagrant = `cd #{directory}; git clone #{url} vagrant; cd vagrant && git checkout production`
      @logs.Debug("cd #{directory}; git clone #{url} vagrant")
      @logs.Debug(output_vagrant)
      if $?.success?
          #
          #This is a temporary fix, or shit won't work.
          #
          output_vagrant_rm_git = `cd #{directory}/vagrant && rm -rf .git`
          #
          #
          #
        begin
          temp_file = File.open(directory + '/vagrant/example.settings.json', 'w+')
          temp_contents = ''
          temp_file.each {|line| temp_contents += line  }
          temp_contents.gsub!(/PROJECT_NAME/, parameters[:project_name])
          temp_contents.gsub!(/SITE_NAME/, parameters[:project_name])
          temp_contents.gsub!(/SITE_HOST/, parameters[:project_name])

          temp_file.puts(temp_contents)

          temp_file.close()
          @logs.Success("Settings correctly written for vagrant.")

          copy_settings_local = `cd #{directory}/vagrant/ && cp example.settings.json settings.json && cp settings.json local.settings.json`

          if $?.success?
            @logs.Success("Correctly copied the settings file to settings.json and local.settings.json.")
          else
            @logs.Error("Failed to copy the settings file to settings.json and local.settings.json")
          end
          return true
        rescue
          return false
        end
      else
        return false
      end
    end
  end
end
