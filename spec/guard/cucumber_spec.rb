require 'spec_helper'

describe Guard::Cucumber do

  before do
    Dir.stub(:glob).and_return ['features/a.feature', 'features/subfolder/b.feature']
  end

  let(:cucumber) { Guard::Cucumber.new }
  let(:runner)   { Guard::Cucumber::Runner }

  describe '.run_all' do
    it 'uses the normal runner' do
      runner.should_receive(:run).with(['features'], :message => 'Run all Cucumber features')
      cucumber.run_all
    end
  end

  describe '.run_on_change' do
    it 'runs cucumber with all features' do
      runner.should_receive(:run).with(['features'], :message => 'Run all Cucumber features')
      cucumber.run_on_change(['features'])
    end

    it 'runs cucumber with single feature' do
      runner.should_receive(:run).with(['features/a.feature'], {})
      cucumber.run_on_change(['features/a.feature'])
    end

    it 'should pass the matched paths to the inspector for cleanup' do
      runner.stub(:run)
      Guard::Cucumber::Inspector.should_receive(:clean).with(['features']).and_return ['features']
      cucumber.run_on_change(['features'])
    end
  end
end
