require 'guard'
require 'guard/guard'
require 'cucumber'

module Guard
  class Cucumber < Guard

    autoload :Runner, 'guard/cucumber/runner'
    autoload :Inspector, 'guard/cucumber/inspector'

    def initialize(watchers=[], options={})
      super
      @options = {
          :all_after_pass => true,
          :all_on_start => true,
          :keep_failed => true,
          :cli => '--no-profile --color --format progress --strict'
      }.update(options)

      @last_failed = false
      @failed_paths = []
    end

    def start
      run_all if @options[:all_on_start]
    end

    def run_all
      passed = Runner.run(['features'], options.merge({ :message => 'Running all features' }))

      @failed_paths = [] if passed
      @last_failed = !passed
    end

    def reload
      @failed_paths = []
    end

    def run_on_change(paths)
      paths += @failed_paths if @options[:keep_failed]
      paths = Inspector.clean(paths)
      passed = Runner.run(paths, paths.include?('features') ? options.merge({ :message => 'Running all features' }) : options)

      if passed
        # clean failed paths memory
        @failed_paths -= paths if @options[:keep_failed]
        # run all the specs if the changed specs failed, like autotest
        run_all if @last_failed && @options[:all_after_pass]
      else
        # remember failed paths for the next change
        @failed_paths += read_failed_features if @options[:keep_failed]
        # track whether the changed feature failed for the next change
        @last_failed = true
      end
    end

    private

    def read_failed_features
      failed = []

      if File.exist?('rerun.txt')
        failed = File.open('rerun.txt').read.split(' ')
        File.delete('rerun.txt')
      end

      failed
    end

  end
end
