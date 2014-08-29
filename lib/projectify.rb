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
end
