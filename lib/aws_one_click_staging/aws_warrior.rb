require 'fileutils'
require 'aws-sdk'
require 'yaml'

module AwsOneClickStaging

  class AwsWarrior

    def initialize
      # read config file
      @config_dir = "#{ENV['HOME']}/.config"
      @config_file = File.expand_path("#{@config_dir}/aws_one_click_staging.yml")
      return nil if create_config_file_if_needed!
      @config = YAML.load(read_config_file)
    end

    def clone_rds
      setup_aws_credentials

      @c = Aws::RDS::Client.new

      delete_snapshot_for_staging!
      create_new_snapshot_for_staging!

      delete_staging_db_instance!
      spawn_new_staging_db_instance!
    end

    def clone_s3_bucket
      setup_aws_credentials

      from_creds = { aws_access_key_id: @access_key_id,
        aws_secret_access_key: @secret_access_key,
        bucket: @aws_production_bucket}
      to_creds = { aws_access_key_id: @access_key_id,
        aws_secret_access_key: @secret_access_key,
        bucket: @aws_staging_bucket}

      bs = BucketSyncService.new(from_creds, to_creds)
      bs.debug = true

      puts "beginning clone of S3 bucket, this can go on for tens of minutes..."
      bs.perform
    end

    def get_fancy_string_of_staging_db_uri
      l = 66
      msg = ""
      msg += "*" * l + "\n"
      msg += "* "
      msg += get_fresh_db_instance_state(@db_instance_id_staging).endpoint.address
      msg += "  *\n"
      msg += "*" * l
      msg
    end


    private

    def setup_aws_credentials
      aws_region = @config["aws_region"]
      @access_key_id = @config["aws_access_key_id"]
      @secret_access_key = @config["aws_secret_access_key"]
      @master_username = @config["aws_master_username"]
      @master_user_password = @config["aws_master_user_password"]
      @aws_production_bucket = @config["aws_production_bucket"]
      @aws_staging_bucket = @config["aws_staging_bucket"]

      @db_instance_id_production = @config["db_instance_id_production"]
      @db_instance_id_staging = @config["db_instance_id_staging"]
      @db_snapshot_id = @config["db_snapshot_id"]

      Aws.config.update({ region: aws_region,
        credentials: Aws::Credentials.new(@access_key_id, @secret_access_key) })
    end

    def delete_snapshot_for_staging!
      puts "deleting old staging db snapshot"
      response = @c.delete_db_snapshot(db_snapshot_identifier: @db_snapshot_id)

      sleep 1 while response.db_snapshot.percent_progress != 100
      true
    rescue
      false
    end

    def create_new_snapshot_for_staging!
      puts "creating new snapshot... this takes like 170 seconds..."
      response = @c.create_db_snapshot({db_instance_identifier: @db_instance_id_production,
        db_snapshot_identifier: @db_snapshot_id })

      sleep 10 while get_fresh_db_snapshot_state.status != "available"
      true
    rescue
      false
    end


    def delete_staging_db_instance!
      puts "Deleting old staging instance... This one's a doozy =/"
      response = @c.delete_db_instance(db_instance_identifier: @db_instance_id_staging,
        skip_final_snapshot: true)

      sleep 10 until db_instance_is_deleted?(@db_instance_id_staging)
    rescue
      false
    end

    def spawn_new_staging_db_instance!
      puts "Spawning a new fully clony RDS db instance for staging purposes"
      response = @c.create_db_instance(db_instance_identifier: @db_instance_id_staging,
        db_instance_class: "db.t1.micro",
        engine: "postgres",
        master_username: @master_username,
        master_user_password: @master_user_password,
        allocated_storage: "10")

      sleep 10 while get_fresh_db_instance_state(@db_instance_id_staging).db_instance_status != "available"
    end


    # we use this methods cause amazon lawl-pain
    def get_fresh_db_snapshot_state
      @c.describe_db_snapshots(db_snapshot_identifier: @db_snapshot_id).db_snapshots.first
    end

    def get_fresh_db_instance_state(db_instance_id)
      @c.describe_db_instances(db_instance_identifier: db_instance_id).db_instances.first
    end

    def db_instance_is_deleted?(db_instance_id)
      @c.describe_db_instances(db_instance_identifier: db_instance_id).db_instances.first
      false
    rescue Aws::RDS::Errors::DBInstanceNotFound => e
      true
    end




    def read_config_file
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
