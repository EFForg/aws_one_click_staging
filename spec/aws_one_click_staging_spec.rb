require 'spec_helper'

describe AwsOneClickStaging do

  before :each do
    @mocked_home = "/tmp/aws_one_click_staging_mock_home" # intentionally non-dry for feeling good about deleting it

    reset_test_env
  end

  it 'has a version number' do
    expect(AwsOneClickStaging::VERSION).not_to be nil
  end

  it 'can create config files' do
    a = AwsOneClickStaging.list

    expect(File.exists?("#{ENV['HOME']}/.config/aws_one_click_staging.yml")).to be true
  end



end
