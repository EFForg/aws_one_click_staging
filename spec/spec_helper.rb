$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'aws_one_click_staging'

# let the app know we're testing, don't STDOUT
ENV['aws_one_click_staging_testing'] = 'true'

# Mock our home directory
ENV['HOME'] = "/tmp/aws_one_click_staging_mock_home"


def reset_test_env
  FileUtils.rm_rf "#{@mocked_home}"
  FileUtils.mkdir_p @mocked_home
end
