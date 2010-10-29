require 'spec_helper'

describe Guard::Cucumber::Runner do
  let(:runner) { Guard::Cucumber::Runner }

  before do
    @configuration = ::Cucumber::Cli::Configuration.new
    @runtime = ::Cucumber::Runtime.new
    runner.stub(:run_cucumber)
  end

  describe '.run' do
    context 'when no message option is passed for one feature' do
      before do
        @configuration.parse!(['features/a.feature'])
      end
      it 'shows a default message' do
        Guard::UI.should_receive(:info).with('Run Cucumber feature features/a.feature', { :reset => true })
        runner.run(@runtime, @configuration)
      end
    end

    context 'when no message option is passed for one feature' do
      before do
        @configuration.parse!(['features/a.feature', 'features/b.feature'])
      end
      it 'shows a default message' do
        Guard::UI.should_receive(:info).with('Run Cucumber features features/a.feature features/b.feature', { :reset => true })
        runner.run(@runtime, @configuration)
      end
    end

    context 'when a custom message option is passed' do
       before do
        @configuration.parse!(['features'])
       end
       it 'shows the custom message' do
        Guard::UI.should_receive(:info).with('Custom Message', { :reset => true })
        runner.run(@runtime, @configuration, { :message => 'Custom Message' })
      end
    end
  end

end
