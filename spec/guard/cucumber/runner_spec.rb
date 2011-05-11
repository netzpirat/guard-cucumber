require 'spec_helper'

describe Guard::Cucumber::Runner do
  let(:runner) { Guard::Cucumber::Runner }
  let(:null_device) { RUBY_PLATFORM.index('mswin') ? 'NUL' : '/dev/null' }

  describe '#run' do
    context "when passed an empty paths list" do
      it "returns false" do
        runner.run([]).should be_false
      end
    end

    context 'with a :rvm option' do
      it 'executes cucumber through the rvm versions' do
        runner.should_receive(:system).with(
            "rvm 1.8.7,1.9.2 exec bundle exec cucumber --require #{ @lib_path.join('guard/cucumber/notification_formatter.rb') } --format Guard::Cucumber::NotificationFormatter --out #{ null_device } --require features features"
        )
        runner.run(['features'], { :rvm => ['1.8.7', '1.9.2'] })
      end
    end

    context 'with a :bundler option' do
      it 'runs without bundler when false' do
        runner.should_receive(:system).with(
            "cucumber --require #{ @lib_path.join('guard/cucumber/notification_formatter.rb') } --format Guard::Cucumber::NotificationFormatter --out #{ null_device } --require features features"
        )
        runner.run(['features'], { :bundler => false })
      end
    end

    context 'with a :cli option' do
      it 'appends the cli arguments when calling cucumber' do
        runner.should_receive(:system).with(
            "bundle exec cucumber --custom command --require #{ @lib_path.join('guard/cucumber/notification_formatter.rb') } --format Guard::Cucumber::NotificationFormatter --out #{ null_device } --require features features"
        )
        runner.run(['features'], { :cli => "--custom command" })
      end
    end

    context 'with a :notification option' do
      it 'does not add the guard notification listener' do
        runner.should_receive(:system).with(
            "bundle exec cucumber features"
        )
        runner.run(['features'], { :notification => false })
      end
    end
  end

end
