require 'fileutils'

module AwsOneClickStaging

  class AwsWarrior

    def initialize
      # read config file
      @config_dir = "#{ENV['HOME']}/.config"
      @config_file = File.expand_path("#{@config_dir}/aws_one_click_staging.yml")
      config = read_config_file
      # make clone of RDS

      # make clone of bucket
    end

    

    def read_config_file
      return if create_config_file_if_needed!
      config = File.read(@config_file)
    end

    def create_config_file_if_needed!
      return false if File.exists?(@config_file)
      msg = ""
      msg += "Config file not found, creating...\n\n"

      # copy example config file to config file path
      FileUtils.mkdir_p @config_dir
      FileUtils.cp("#{SOURCE_ROOT}/config/aws_one_click_staging.yml", @config_file)

      msg += "An empty config file was created for you in #{@config_file}\n"
      msg += "Please populate it with the correct information and run this \n"
      msg += "command again.  \n"

      true

    end

  end

end
