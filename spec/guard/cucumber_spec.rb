require 'spec_helper'

describe Guard::Cucumber do
  subject { Guard::Cucumber.new }

  before do
    Guard::Cucumber::Runner.stub(:popen2e).and_return ['', 0]
  end

  describe '#run_all' do
    it 'runs all features' do
      Guard::Cucumber::Runner.should_receive(:run).with(['features'], :message => 'Run all Cucumber features')
      subject.run_all
    end
  end

  describe '#run_on_change' do
    it 'runs cucumber with paths' do
      Guard::Cucumber::Runner.should_receive(:run).with(['features'], {})
      subject.run_on_change(['features'])
    end

    it 'should pass the matched paths to the inspector for cleanup' do
      Guard::Cucumber::Inspector.should_receive(:clean).with(['features']).and_return ['features']
      subject.run_on_change(['features'])
    end
  end
end
