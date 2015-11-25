require "pry"
require "aws_one_click_staging/aws_warrior"
require "aws_one_click_staging/version"

SOURCE_ROOT = File.expand_path("#{File.dirname(__FILE__)}/..")

module AwsOneClickStaging

  def self.stage

    warrior = AwsWarrior.new

  end

  def self.list
    warrior = AwsWarrior.new
    puts "This is aws_one_click_staging, use stage to set things up"
  end



end
