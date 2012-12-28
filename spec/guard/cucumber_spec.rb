require 'spec_helper'

describe Guard::Cucumber do

  before do
    Dir.stub(:glob).and_return ['features/a.feature', 'features/subfolder/b.feature']
  end

  let(:default_options) do
    {
        :all_after_pass => true,
        :all_on_start   => true,
        :keep_failed    => true,
        :cli            => '--no-profile --color --format progress --strict',
        :feature_sets   => ['features']
    }
  end

  let(:guard) { Guard::Cucumber.new }
  let(:runner) { Guard::Cucumber::Runner }

  describe '#initialize' do
    context 'when no options are provided' do
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

      it 'sets a default :feature_sets option' do
        guard.options[:feature_sets].should eql ['features']
      end
    end

    context 'with other options than the default ones' do
      let(:guard) { Guard::Cucumber.new(nil, { :all_after_pass => false,
                                               :all_on_start   => false,
                                               :keep_failed    => false,
                                               :cli            => '--color',
                                               :feature_sets   => ['feature_set_a', 'feature_set_b'],
                                               :focus_on       => '@focus' }) }

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

      it 'sets the provided :feature_sets option' do
        guard.options[:feature_sets].should eql ['feature_set_a', 'feature_set_b']
      end

      it 'sets the provided :focus_on option' do
        guard.options[:focus_on].should eql '@focus'
      end

    end
  end

  describe '#start' do
    it 'calls #run_all' do
      runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features')).and_return(true)
      guard.start
    end

    context 'with the :all_on_start option is false' do
      let(:guard) { Guard::Cucumber.new([], :all_on_start => false) }

      it 'does not call #run_all' do
        runner.should_not_receive(:run).with(['features'], default_options.merge(:all_on_start => false,
                                                                                 :message      => 'Running all features'))
        guard.start
      end
    end
  end

  describe '#run_all' do
    it 'runs all features' do
      runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features')).and_return(true)
      guard.run_all
    end

    it 'cleans failed memory if passed' do
      runner.should_receive(:run).with(['features/foo'], default_options).and_return(false)
      expect { guard.run_on_changes(['features/foo']) }.to throw_symbol :task_has_failed
      runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features')).and_return(true)
      runner.should_receive(:run).with(['features/bar'], default_options).and_return(true)
      guard.run_on_changes(['features/bar'])
    end

    it 'saves failed features' do
      runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features')).and_return(false)
      File.should_receive(:exist?).with('rerun.txt').and_return true
      file = mock('file')
      file.should_receive(:read).and_return 'features/foo'
      File.stub(:open).and_yield file
      File.should_receive(:delete).with('rerun.txt')
      expect { guard.run_all }.to throw_symbol :task_has_failed

      runner.should_receive(:run).with(['features/bar', 'features/foo'], default_options).and_return(true)
      runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features')).and_return(true)
      guard.run_on_changes(['features/bar'])
    end

    context 'with the :feature_sets option' do
      non_standard_feature_set = ['a_non_standard_feature_set']
      let(:guard) { Guard::Cucumber.new([], { :feature_sets => non_standard_feature_set }) }

      it 'passes the feature sets as paths to runner' do
        runner.should_receive(:run).with(non_standard_feature_set, anything).and_return(true)

        guard.run_all
      end
    end

    context 'with the :cli option' do
      let(:guard) { Guard::Cucumber.new([], { :cli => '--color' }) }

      it 'directly passes :cli option to runner' do
        runner.should_receive(:run).with(['features'], default_options.merge(:cli     => '--color',
                                                                             :message => 'Running all features')).and_return(true)
        guard.run_all
      end
    end

    context 'when the :keep_failed option is false' do
      let(:guard) { Guard::Cucumber.new([], :keep_failed => false) }
      let(:run_options) { default_options.merge :keep_failed => false }

      it 'does not save failed features if keep_failed is disabled' do
        runner.should_receive(:run).with(['features'], run_options.merge(:message => 'Running all features')).and_return(false)
        File.should_not_receive(:exist?).with('rerun.txt')
        expect { guard.run_all }.to throw_symbol :task_has_failed
        runner.should_receive(:run).with(['features/bar'], run_options).and_return(true)
        runner.should_receive(:run).with(['features'], run_options.merge(:message => 'Running all features')).and_return(true)
        guard.run_on_changes(['features/bar'])
      end
    end

    context 'with a :run_all option' do
      let(:guard) { Guard::Cucumber.new([], { :rvm => ['1.8.7', '1.9.2'],
                                              :cli => '--color',
                                              :run_all => { :cli => '--format progress' } }) }

      it 'allows the :run_all options to override the default_options' do
        runner.should_receive(:run).with(anything, hash_including(:cli => '--format progress', :rvm => ['1.8.7', '1.9.2'])).and_return(true)
        guard.run_all
      end
    end
  end

  describe '#reload' do
    it 'clears failed_path' do
      runner.should_receive(:run).with(['features/foo'], default_options).and_return(false)
      expect { guard.run_on_changes(['features/foo']) }.to throw_symbol :task_has_failed
      guard.reload
      runner.should_receive(:run).with(['features/bar'], default_options).and_return(true)
      runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features')).and_return(true)
      guard.run_on_changes(['features/bar'])
    end
  end

  describe '#run_on_changes' do
    it 'runs cucumber with all features' do
      runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features')).and_return(true)
      guard.run_on_changes(['features'])
    end

    it 'runs cucumber with single feature' do
      runner.should_receive(:run).with(['features/a.feature'], default_options).and_return(true)
      guard.run_on_changes(['features/a.feature'])
    end

    it 'passes the matched paths to the inspector for cleanup' do
      runner.stub(:run).and_return(true)
      Guard::Cucumber::Inspector.should_receive(:clean).with(['features'], ['features']).and_return ['features']
      guard.run_on_changes(['features'])
    end

    it 'calls #run_all if the changed specs pass after failing' do
      runner.should_receive(:run).with(['features/foo'], default_options).and_return(false, true)
      runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features')).and_return(true)
      expect { guard.run_on_changes(['features/foo']) }.to throw_symbol :task_has_failed
      guard.run_on_changes(['features/foo'])
    end

    it 'does not call #run_all if the changed specs pass without failing' do
      runner.should_receive(:run).with(['features/foo'], default_options).and_return(true)
      runner.should_not_receive(:run).with(['features'], default_options.merge(:message => 'Running all features'))
      guard.run_on_changes(['features/foo'])
    end

    context 'with a :cli option' do
      let(:guard) { Guard::Cucumber.new([], { :cli => '--color' }) }

      it 'directly passes the :cli option to the runner' do
        runner.should_receive(:run).with(['features'], default_options.merge(:cli => '--color', :message => 'Running all features')).and_return(true)
        guard.run_on_changes(['features'])
      end
    end

    context 'when the :all_after_pass option is false' do
      let(:guard) { Guard::Cucumber.new([], :all_after_pass => false) }

      it 'does not call #run_all if the changed specs pass after failing but the :all_after_pass option is false' do
        runner.should_receive(:run).with(['features/foo'], default_options.merge(:all_after_pass => false)).and_return(false, true)
        runner.should_not_receive(:run).with(['features'], default_options.merge(:all_after_pass => false, :message => 'Running all features'))
        expect { guard.run_on_changes(['features/foo']) }.to throw_symbol :task_has_failed
        guard.run_on_changes(['features/foo'])
      end
    end

    context 'with a rerun.txt file' do
      before do
        file = mock('file')
        file.stub(:read).and_return 'features/foo'
        File.stub(:open).and_yield file
      end

      it 'keeps failed spec and rerun later' do
        runner.should_receive(:run).with(['features/foo'], default_options).and_return(false)
        File.should_receive(:exist?).with('rerun.txt').and_return true
        File.should_receive(:delete).with('rerun.txt')
        expect { guard.run_on_changes(['features/foo']) }.to throw_symbol :task_has_failed
        runner.should_receive(:run).with(['features/bar', 'features/foo'], default_options).and_return(true)
        runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features')).and_return(true)
        guard.run_on_changes(['features/bar'])
        runner.should_receive(:run).with(['features/bar'], default_options).and_return(true)
        guard.run_on_changes(['features/bar'])
      end
    end

    context 'with the :change_format option' do
      let(:guard) { Guard::Cucumber.new([], default_options.merge(:cli => cli, :change_format => 'pretty')) }
      let(:cli) { '-c --format progress --format OtherFormatter --out /dev/null --profile guard' }
      let(:expected_cli) { '-c --format pretty --format OtherFormatter --out /dev/null --profile guard' }

      it 'uses the change formatter if one is given' do
        runner.should_receive(:run).with(['features/bar'], default_options.merge(:change_format => 'pretty',
                                                                                 :cli           => expected_cli)).and_return(true)
        guard.run_on_changes(['features/bar'])
      end
    end
  end
end
