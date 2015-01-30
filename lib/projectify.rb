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

    self.parse_files(@path)

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
    FileUtils.rm_rf("#{target_path}/.git")

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
    FileUtils.cp_r(self.get_tree(from), to)
    FileUtils.rm_rf(from)
  end

  ##
   # Symlink the default site directory to the site directory generated by
   # projectify.
  ##
  def symlink_site_directory()
    default_site_dir = "#{@path}/docroot/sites/default"
    site_dir = "#{@path}/docroot/sites/#{@parameters[:project_name]}"

    if Dir.exists? default_site_dir
      FileUtils.rm_rf(default_site_dir)
    end

    if Dir.exists? site_dir
      system("cd #{@path}/docroot/sites && ln -s #{@parameters[:project_name]} default")
    end
  end

  def drush_make()
    @logs.Debug("cd #{@path} && drush make #{@parameters[:project_name]}.make drupal --concurrency=5")
    system("cd  #{@path} && drush make #{@parameters[:project_name]}.make drupal --concurrency=5")
    system("cd  #{@path} && rm drupal/.gitignore")
    self.merge_files 'drupal/.', 'docroot'

    if $?.success?
      @logs.Success("Drush make succeeded")
    else
      @logs.Error("Drush make failed")
    end
  end

  def get_tree(dir)
    return Dir.glob("#{dir}/*", File::FNM_DOTMATCH) - ["#{dir}/.", "#{dir}/.."]
  end

  def create_vagrant_files(directory, parameters, url)
    if Dir.exist? directory
      output_vagrant = `cd #{directory} && git clone #{url} --branch=master vagrant`
      @logs.Debug("cd #{directory} && git clone #{url} --branch=master vagrant")
      @logs.Debug(output_vagrant)

      if $?.success?
        settings_path = "#{directory}/vagrant/settings.json"
        FileUtils.rm_rf("#{directory}/vagrant/.git")
        FileUtils.cp("#{directory}/vagrant/example.settings.json", settings_path)
        data = self.replace_placeholders(File.read(settings_path))
        File.open(settings_path, "w") {|file| file.puts data }
        @logs.Success("Correctly copied the settings file to settings.json.")

        return true
      end
    end

    return false
  end

  def create_boilerplate_theme(repository)
    theme_dir = "#{@path}/docroot/sites/#{@parameters[:project_name]}/themes/custom"
    boilerplate_theme_dir = "#{theme_dir}/#{@parameters[:project_name]}_omega"

    self.run("mkdir -p #{theme_dir}")
    self.run("cd #{theme_dir} && git clone #{repository} --branch=omega #{@parameters[:project_name]}_omega")

    if $?.success?
      FileUtils.rm_rf("#{boilerplate_theme_dir}/.git")
      FileUtils.mv("#{boilerplate_theme_dir}/crosscheck_theme.info", "#{boilerplate_theme_dir}/#{@parameters[:project_name]}_omega.info")
      @logs.Success("Set up the theme in #{theme_dir}/#{@parameters[:project_name]}_omega")
      return true
    end

    return false
  end

  def run(command)
    @logs.Debug(command)
    system(command)
  end
end
