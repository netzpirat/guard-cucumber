require 'spec_helper'

describe Guard::Cucumber::Runner do
  let(:runner) { Guard::Cucumber::Runner }

  describe '.run' do
    context 'when no message option is passed' do
      it 'shows a default message' do
        runner.stub(:popen2e).and_return ['', 0]
        Guard::UI.should_receive(:info).with('Run Cucumber features features/a.feature', { :reset => true })
        runner.run(['features/a.feature'])
      end
    end

    context 'when a custom message option is passed' do
      it 'shows the custom message' do
        runner.stub(:popen2e).and_return ['', 0]
        Guard::UI.should_receive(:info).with('Custom Message', { :reset => true })
        runner.run(['features/a.feature'], { :message => 'Custom Message' })
      end
    end
  end

  describe '.cucumber_command' do
    it 'passes the paths to the cucumber command' do
      runner.stub(:bundler?).and_return false
      runner.should_receive(:popen2e).with('cucumber --color features/a.feature').and_return true
      runner.run(['features/a.feature'])
    end

    it 'uses the gem bundler when a gemfile exists' do
      runner.stub(:bundler?).and_return true
      runner.should_receive(:popen2e).with('bundle exec cucumber --color features/a.feature').and_return true
      runner.run(['features/a.feature'])
    end
  end
end
