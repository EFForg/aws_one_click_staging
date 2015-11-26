require 'fileutils'
require 'aws-sdk'

module AwsOneClickStaging

  class AwsWarrior

    def initialize
      # read config file
      @config_dir = "#{ENV['HOME']}/.config"
      @config_file = File.expand_path("#{@config_dir}/aws_one_click_staging.yml")
      config = read_config_file
    end

    def clone_rds
      

      @db_instance_id_production = "actioncenter-staging"
      @db_instance_id_staging = "actioncenter-staging-test"
      @db_snapshot_id = "actioncenter-snapshot-for-staging"

      Aws.config.update({ region: aws_region,
        credentials: Aws::Credentials.new(access_key_id, secret_access_key) })

      @c = Aws::RDS::Client.new


      binding.pry
      exit

      # Delete snapshot if it exists?
      delete_snapshot_for_staging!
      create_new_snapshot_for_staging!

      delete_staging_db_instance!
      spawn_new_staging_db_instance!
    end

    def self.clone_s3_bucket

    end


    def delete_snapshot_for_staging!
      puts "deleting old staging db snapshot"
      response = @c.delete_db_snapshot(db_snapshot_identifier: @db_snapshot_id)

      sleep 1 while response.percent_progress != 100
      true
    rescue
      false
    end

    def create_new_snapshot_for_staging!
      puts "creating new snapshot... this takes like 70 seconds..."
      response = @c.create_db_snapshot({db_instance_identifier: @db_instance_id_production,
        db_snapshot_identifier: @db_snapshot_id })

      sleep 10 while get_fresh_db_snapshot_state.status != "available"
      true
    rescue
      false
    end


    def delete_staging_db_instance!
      response = @c.delete_db_instance(db_instance_identifier: @db_instance_id_staging)

      sleep 2 while response.percent_progress != 100
    rescue
      false
    end

    def spawn_new_staging_db_instance!
      response = @c.create_db_instance(db_instance_identifier: @db_instance_id_staging,
        db_instance_class: "db.t1.micro",
        engine: "postgres",
        master_username: @master_username,
        master_user_password: @master_user_password,
        allocated_storage: "10")

      sleep 10 while get_fresh_db_instance_state.db_instance_status != "available"
    end


    # we use this methods cause amazon lawl-pain
    def get_fresh_db_snapshot_state
      @c.describe_db_snapshots(db_snapshot_identifier: @db_snapshot_id).db_snapshots.first
    end

    def get_fresh_db_instance_state
      @c.describe_db_instances(db_instance_identifier: @db_instance_id_staging).db_instances.first
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
