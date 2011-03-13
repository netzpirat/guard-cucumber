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
          "bundle exec cucumber --require #{@lib_path.join('guard/cucumber/cucumber_formatter.rb')} --format CucumberFormatter --color --drb --require features/support --require features/step_definitions features"
      )
      runner.run(['features'], { :drb => true })
    end

    it 'runs with port argument' do
      runner.should_receive(:system).with(
          "bundle exec cucumber --require #{@lib_path.join('guard/cucumber/cucumber_formatter.rb')} --format CucumberFormatter --color --drb --port 1234 --require features/support --require features/step_definitions features"
      )
      runner.run(['features'], { :drb => true, :port => 1234 })
    end

    it 'runs with a profile argument' do
      runner.should_receive(:system).with(
          "bundle exec cucumber --profile profile --require #{@lib_path.join('guard/cucumber/cucumber_formatter.rb')} --format CucumberFormatter --color --require features features"
      )
      runner.run(['features'], { :profile => 'profile' })
    end

    it 'runs without a profile argument' do
      runner.should_receive(:system).with(
          "bundle exec cucumber --require #{@lib_path.join('guard/cucumber/cucumber_formatter.rb')} --format CucumberFormatter --color --require features features"
      )
      runner.run(['features'], { })
    end

    context 'with a command argument' do
      it 'runs with the command argument' do
        runner.should_receive(:system).with(
            "bundle exec cucumber --require #{@lib_path.join('guard/cucumber/cucumber_formatter.rb')} --format CucumberFormatter --color --require features --custom command features"
        )
        runner.run(['features'], { :command => "--custom command" })
      end

      it 'runs with a command argument that overwrites require' do
        runner.should_receive(:system).with(
            "bundle exec cucumber --require #{@lib_path.join('guard/cucumber/cucumber_formatter.rb')} --format CucumberFormatter --color --require features/support features"
        )
        runner.run(['features'], { :command => "--require features/support" })
      end
    end
  end
end
