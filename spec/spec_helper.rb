$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "pry"
require 'aws_one_click_staging'

# let the app know we're testing, don't STDOUT
ENV['aws_one_click_staging_testing'] = 'true'

# Mock our home directory
ENV['HOME'] = "/tmp/aws_one_click_staging_mock_home"


def reset_test_env
  FileUtils.rm_rf "#{@mocked_home}"
  FileUtils.mkdir_p "#{@mocked_home}/.config"

  working_amazon_credentials_file = "#{SOURCE_ROOT}/config/aws_actual_fffing_secrets.yml"
  if File.exists?(working_amazon_credentials_file)
    FileUtils.cp(working_amazon_credentials_file, "#{@mocked_home}/.config/aws_one_click_staging.yml")
  end
end
