require 'spec_helper'

describe Guard::Cucumber::Runner do
  let(:runner) { Guard::Cucumber::Runner }

  describe '#run' do
    it 'runs with rvm exec' do
      runner.should_receive(:system).with(
        "rvm 1.8.7,1.9.2 exec bundle exec cucumber --require #{@lib_path.join('guard/cucumber/cucumber_formatter.rb')} --format CucumberFormatter --color --require features features"
      )
      runner.run(['features'], { :rvm => ['1.8.7', '1.9.2'] })
    end

    it 'runs without bundler' do
      runner.should_receive(:system).with(
        "cucumber --require #{@lib_path.join('guard/cucumber/cucumber_formatter.rb')} --format CucumberFormatter --color --require features features"
      )
      runner.run(['features'], { :bundler => false })
    end

    it 'runs without color argument' do
      runner.should_receive(:system).with(
        "bundle exec cucumber --require #{@lib_path.join('guard/cucumber/cucumber_formatter.rb')} --format CucumberFormatter --require features features"
      )
      runner.run(['features'], { :color => false })
    end

    it 'runs with drb argument' do
      runner.should_receive(:system).with(
        "bundle exec cucumber --require #{@lib_path.join('guard/cucumber/cucumber_formatter.rb')} --format CucumberFormatter --color --drb --require features features"
      )
      runner.run(['features'], { :drb => true })
    end

    it 'runs with port argument' do
      runner.should_receive(:system).with(
        "bundle exec cucumber --require #{@lib_path.join('guard/cucumber/cucumber_formatter.rb')} --format CucumberFormatter --color --drb --port 1234 --require features features"
      )
      runner.run(['features'], { :drb => true, :port => 1234 })
    end
    it 'runs with a profile argument' do
      runner.should_receive(:system).with(
        "bundle exec cucumber --profile profile --require #{@lib_path.join('guard/cucumber/cucumber_formatter.rb')} --format CucumberFormatter --color --require features features"
      )
      runner.run(['features'], { :profile => 'profile'})
    end
    it 'runs without a profile argument' do
      runner.should_receive(:system).with(
        "bundle exec cucumber --require #{@lib_path.join('guard/cucumber/cucumber_formatter.rb')} --format CucumberFormatter --color --require features features"
      )
      runner.run(['features'], {})
    end
  end
end

