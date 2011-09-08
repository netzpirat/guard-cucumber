require 'spec_helper'

describe Guard::CucumberVersion do
  describe 'VERSION' do
    it 'defines the version' do
      Guard::CucumberVersion::VERSION.should match /\d+.\d+.\d+/
    end
  end
end
