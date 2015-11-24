require 'fileutils'

module AwsOneClickStaging

  class AwsWarrior

    def initialize
      # read config file
      @config_file = File.expand_path("~/.config/aws_one_click_staging.yml")
      config = read_config_file
      # make clone of RDS

      # make clone of bucket
    end

    def read_config_file
      create_config_file_if_needed!
      config = File.read(@config_file)

    end

    def create_config_file_if_needed!
      return if File.exists?(@config_file)
      puts "Config file not found, creating...\n"
      # copy example config file to config file path
      example_config_file_source = File.expand_path("~/.config/aws_one_click_staging.yml")
      binding.pry
      FileUtils.cp("#{SOURCE_ROOT}/config/config", @config_file) unless File.exists? @config_file



      puts "An empty config file was created for you in #{config_file_path}"
      puts "Please populate it with the correct information and run this "
      puts "command again.  "
      exit
    end

    def create_config_file_if_needed!
      FileUtils.mkdir_p @user_defined_templates_path
      FileUtils.cp("#{SOURCE_ROOT}/config/config", @config_file) unless File.exists? @config_file
    end



  end

end
