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
      passed = Runner.run(['features'], options.merge(options[:run_all] || {}).merge(:message => 'Running all features'))

      if passed
        @failed_paths = []
      else
        @failed_paths = read_failed_features if @options[:keep_failed]
      end

      @last_failed = !passed
      
      passed
    end

    def reload
      @failed_paths = []
      
      true
    end

    def run_on_change(paths)
      paths += @failed_paths if @options[:keep_failed]
      paths = Inspector.clean(paths)
      options = @options[:change_format] ? change_format(@options[:change_format]) : @options
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
      
      passed
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

    def change_format(format)
      cli_parts = @options[:cli].split(" ")
      cli_parts.each_with_index do |part, index|
        if part == "--format" && cli_parts[index + 2] != "--out"
          cli_parts[index + 1] = format
        end
      end
      @options.merge(:cli => cli_parts.join(" "))
    end

  end
end
