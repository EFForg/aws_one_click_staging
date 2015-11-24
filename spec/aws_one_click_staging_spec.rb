require 'spec_helper'

describe AwsOneClickStaging do
  it 'has a version number' do
    expect(AwsOneClickStaging::VERSION).not_to be nil
  end

  it 'can read config files' do
    a = AwsOneClickStaging::AwsWarrior.new
    binding.pry
    expect(false).to eq(true)
  end
end
