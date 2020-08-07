module Brew
  class HomeBrewError < StandardError; end
  class HomeBrewNotInstalled < HomeBrewError; end

  class HomeBrew
    
    DEFAULT_BREW_PATH = '/usr/local/bin/brew'.freeze

    attr_reader :brew_path
    private :brew_path

    def initialize(brew_path: DEFAULT_BREW_PATH)
      @brew_path = brew_path
      raise HomeBrewNotInstalled unless File.executable?(brew_path)
    end

    def install(formula)
      install_command = "#{brew_path} install '#{formula}'"
      run_command(install_command)
    rescue => e
      raise HomeBrewError, e
    end

    def update
      update_command = "#{brew_path} update"
      run_command(update_command)
    rescue => e
      raise HomeBrewError, e
    end

    def upgrade(formula)
      update_command = "#{brew_path} upgrade '#{formula}'"
      run_command(update_command)
    rescue => e
      raise HomeBrewError, e
    end

    def uninstall(formula)
      update_command = "#{brew_path} uninstall '#{formula}'"
      run_command(update_command)
    rescue => e
      raise HomeBrewError, e
    end

    private
    
    def run_command(command)
      IO.popen(command, 'r+') do |io|
        while line = io.gets
          $stdout.puts line
        end
        io.close
      end
      
      raise HomeBrewError unless $?.success?
    end
  end
end