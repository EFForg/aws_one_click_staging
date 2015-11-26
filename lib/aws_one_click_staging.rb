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

    puts "operations completed successfully!"
  end

  def self.check
    warrior = AwsWarrior.new # this makes a config file if needed
    puts "This command *would* test that you have the needed "
    puts "permissions on the buckets and rds instances you named "
    puts "in your config file... but alas, you're reading the "
    puts "outputs of a stubbed method..."
  end

end
