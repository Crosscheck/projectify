class Logging
  require 'colorize'

  def initialize(debug_enable)
    @debug_enable = debug_enable
  end

  def Debug(value)
    if @debug_enable == true
      puts '[DEBUG] ' + value.yellow
    end
  end

  def Error(value)
    puts '[ERROR] ' + value.red
  end

  def Success(value)
    puts '[SUCCESS] ' + value.green
  end
end
