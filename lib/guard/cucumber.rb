require 'guard'
require 'guard/guard'
require 'cucumber'

module Guard
  class Cucumber < Guard

    # Need to be an absolute path for the preload runner
    autoload :Runner, File.expand_path(File.join(File.dirname(__FILE__), 'cucumber', 'runners', 'runner'))
    autoload :PreloadRunner, File.expand_path(File.join(File.dirname(__FILE__), 'cucumber', 'runners', 'preload_runner'))
    autoload :Inspector, File.expand_path(File.join(File.dirname(__FILE__), 'cucumber', 'inspector'))

    def start
      PreloadRunner.start if options[:preload]
    end

    def run_all
      runner.run ['features'], options.merge!({ :message => 'Run all Cucumber features' })
    end

    def run_on_change(paths)
      paths = Inspector.clean(paths)
      options.merge!({ :message => 'Run all Cucumber features' }) if paths.include?('features')
      runner.run(paths, options) unless paths.empty?
    end

    private

    def runner
      options[:preload] ? PreloadRunner : Runner
    end

  end
end
