require 'aws_one_click_staging/bucket_sync_service'
require "aws_one_click_staging/aws_warrior"
require "aws_one_click_staging/version"

SOURCE_ROOT = File.expand_path("#{File.dirname(__FILE__)}/..")

module AwsOneClickStaging

  def self.stage
    warrior = AwsWarrior.new
    return if warrior.nil?
    puts "cloning database from amazon... this takes a while..."
    warrior.clone_rds
    puts "cloning s3 bucket from amazon... this takes forever..."
    warrior.clone_s3_bucket

    puts get_fancy_string_of_staging_db_uri

    puts "\nOperations completed successfully!"
  end

  def self.check
    warrior = AwsWarrior.new # this makes a config file if needed
    puts "This command *would* test that you have the needed permissions on the "
    puts "buckets and rds instances you named in your config file... "
    puts "but alas, you're reading the outputs of a stubbed method..."
  end

end
