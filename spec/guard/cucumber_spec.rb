require 'spec_helper'

describe Guard::Cucumber do
  subject { Guard::Cucumber.new }

  before do
    subject.instance_variable_set(:@configuration, ::Cucumber::Cli::Configuration.new)
    subject.instance_variable_set(:@runtime, ::Cucumber::Runtime.new)
    Dir.stub(:glob).and_return ['features/a.feature', 'features/subfolder/b.feature']
  end

  describe '#run_all' do
    it 'runs all features' do
      Guard::Cucumber::Runner.should_receive(:run).with(subject.runtime, subject.configuration, :message => 'Run all Cucumber features')
      subject.run_all
    end
  end

  describe '#run_on_change' do
    it 'runs cucumber with all features' do
      Guard::Cucumber::Runner.should_receive(:run).with(subject.runtime, subject.configuration, :message => 'Run all Cucumber features')
      subject.run_on_change(['features'])
    end

    it 'runs cucumber with single feature' do
      Guard::Cucumber::Runner.should_receive(:run).with(subject.runtime, subject.configuration, {})
      subject.run_on_change(['features/a.feature'])
    end

    it 'should pass the matched paths to the inspector for cleanup' do
      Guard::Cucumber::Runner.stub(:run)
      Guard::Cucumber::Inspector.should_receive(:clean).with(['features']).and_return ['features']
      subject.run_on_change(['features'])
    end
  end
end
