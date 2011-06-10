require 'spec_helper'

describe Guard::Cucumber do

  before do
    Dir.stub(:glob).and_return ['features/a.feature', 'features/subfolder/b.feature']
  end

  let(:default_options) { { :all_after_pass => true, :all_on_start => true, :keep_failed => true, :cli => '--no-profile --color --format progress --strict' } }
  let(:runner) { Guard::Cucumber::Runner }
  subject { Guard::Cucumber.new }

  describe '#initialize' do
    context 'when no options are provided' do
      let(:guard) { Guard::Cucumber.new }

      it 'sets a default :all_after_pass option' do
        guard.options[:all_after_pass].should be_true
      end

      it 'sets a default :all_on_start option' do
        guard.options[:all_on_start].should be_true
      end

      it 'sets a default :keep_failed option' do
        guard.options[:keep_failed].should be_true
      end

      it 'sets a default :cli option' do
        guard.options[:cli].should eql '--no-profile --color --format progress --strict'
      end
    end

    context 'with other options than the default ones' do
      let(:guard) { Guard::Cucumber.new(nil, { :all_after_pass => false, :all_on_start => false, :keep_failed => false, :cli => '--color' }) }

      it 'sets the provided :all_after_pass option' do
        guard.options[:all_after_pass].should be_false
      end

      it 'sets the provided :all_on_start option' do
        guard.options[:all_on_start].should be_false
      end

      it 'sets the provided :keep_failed option' do
        guard.options[:keep_failed].should be_false
      end

      it 'sets the provided :cli option' do
        guard.options[:cli].should eql '--color'
      end
    end
  end

  describe "#start" do
    it "calls #run_all" do
      Guard::Cucumber::Runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features'))
      subject.start
    end

    it "doesn't call #run_all if the :all_on_start option is false" do
      Guard::Cucumber::Runner.should_not_receive(:run).with(['features'], default_options.merge(:all_on_start => false, :message => 'Running all features'))
      subject = Guard::Cucumber.new([], :all_on_start => false)
      subject.start
    end
  end

  describe '#run_all' do
    it 'runs all features' do
      runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features'))
      subject.run_all
    end

    it 'directly passes :cli option to runner' do
      subject = Guard::Cucumber.new([], { :cli => '--color' })
      Guard::Cucumber::Runner.should_receive(:run).with(['features'], default_options.merge(:cli => '--color', :message => 'Running all features'))
      subject.run_all
    end

    it 'should clean failed memory if passed' do
      Guard::Cucumber::Runner.should_receive(:run).with(['features/foo'], default_options).and_return(false)
      subject.run_on_change(['features/foo'])
      Guard::Cucumber::Runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features')).and_return(true)
      subject.run_all
      Guard::Cucumber::Runner.should_receive(:run).with(['features/bar'], default_options).and_return(true)
      subject.run_on_change(['features/bar'])
    end
  end

  describe '#reload' do
    it 'should clear failed_path' do
      Guard::Cucumber::Runner.should_receive(:run).with(['features/foo'], default_options).and_return(false)
      subject.run_on_change(['features/foo'])
      subject.reload
      Guard::Cucumber::Runner.should_receive(:run).with(['features/bar'], default_options).and_return(true)
      Guard::Cucumber::Runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features')).and_return(true)
      subject.run_on_change(['features/bar'])
    end
  end

  describe '#run_on_change' do
    it 'runs cucumber with all features' do
      runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features'))
      subject.run_on_change(['features'])
    end

    it 'runs cucumber with single feature' do
      runner.should_receive(:run).with(['features/a.feature'], default_options)
      subject.run_on_change(['features/a.feature'])
    end

    it 'should pass the matched paths to the inspector for cleanup' do
      runner.stub(:run)
      Guard::Cucumber::Inspector.should_receive(:clean).with(['features']).and_return ['features']
      subject.run_on_change(['features'])
    end

    it 'directly passes the :cli option to the runner' do
      subject = Guard::Cucumber.new([], { :cli => '--color' })
      Guard::Cucumber::Runner.should_receive(:run).with(['features'], default_options.merge(:cli => '--color', :message => 'Running all features'))
      subject.run_on_change(['features'])
    end

    it 'calls #run_all if the changed specs pass after failing' do
      Guard::Cucumber::Runner.should_receive(:run).with(['features/foo'], default_options).and_return(false, true)
      Guard::Cucumber::Runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features'))
      subject.run_on_change(['features/foo'])
      subject.run_on_change(['features/foo'])
    end

    it 'does not call #run_all if the changed specs pass after failing but the :all_after_pass option is false' do
      subject = Guard::Cucumber.new([], :all_after_pass => false)
      Guard::Cucumber::Runner.should_receive(:run).with(['features/foo'], default_options.merge(:all_after_pass => false)).and_return(false, true)
      Guard::Cucumber::Runner.should_not_receive(:run).with(['features'], default_options.merge(:all_after_pass => false, :message => 'Running all features'))
      subject.run_on_change(['features/foo'])
      subject.run_on_change(['features/foo'])
    end

    it 'does not call #run_all if the changed specs pass without failing' do
      Guard::Cucumber::Runner.should_receive(:run).with(['features/foo'], default_options).and_return(true)
      Guard::Cucumber::Runner.should_not_receive(:run).with(['features'], default_options.merge(:message => 'Running all features'))
      subject.run_on_change(['features/foo'])
    end

    it 'should keep failed spec and rerun later' do
      Guard::Cucumber::Runner.should_receive(:run).with(['features/foo'], default_options).and_return(false)
      File.should_receive(:exist?).with('rerun.txt').and_return true
      File.stub_chain(:open, :read).and_return 'features/foo'
      File.should_receive(:delete).with('rerun.txt')
      subject.run_on_change(['features/foo'])
      Guard::Cucumber::Runner.should_receive(:run).with(['features/bar', 'features/foo'], default_options).and_return(true)
      Guard::Cucumber::Runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features')).and_return(true)
      subject.run_on_change(['features/bar'])
      Guard::Cucumber::Runner.should_receive(:run).with(['features/bar'], default_options).and_return(true)
      subject.run_on_change(['features/bar'])
    end

    it "should use the change formatter if one is given" do
      cli = "-c --format progress --format OtherFormatter --out /dev/null --profile guard"
      expected_cli = "-c --format pretty --format OtherFormatter --out /dev/null --profile guard"
      subject = Guard::Cucumber.new([], default_options.merge(:cli => cli, :change_format => 'pretty'))
      Guard::Cucumber::Runner.should_receive(:run).with(['features/bar'], default_options.merge(:change_format => "pretty", :cli => expected_cli))
      subject.run_on_change(['features/bar'])
    end
  end
end
