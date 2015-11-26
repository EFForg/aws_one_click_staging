require 'spec_helper'

describe AwsOneClickStaging do

  before :each do
    @mocked_home = "/tmp/aws_one_click_staging_mock_home" # intentionally non-dry for feeling good about deleting it

    reset_test_env
  end

  it 'has a version number' do
    expect(AwsOneClickStaging::VERSION).not_to be nil
  end

  it 'can check config files' do
    a = AwsOneClickStaging.check

    expect(File.exists?("#{ENV['HOME']}/.config/aws_one_click_staging.yml")).to be true
  end


  describe 'AwsWarrior' do

    before :each do
      @aws_warrior = AwsOneClickStaging::AwsWarrior.new
    end

    it 'can clone an RDS database' do
      #@aws_warrior.clone_rds
    end

    it 'can clone a bitbucket' do
      #@aws_warrior.clone_s3_bucket
    end
  end

end
