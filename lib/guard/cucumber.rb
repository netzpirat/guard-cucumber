require 'guard'
require 'guard/guard'
require 'cucumber'

module Guard
  class Cucumber < Guard

    autoload :Runner, 'guard/cucumber/runner'
    autoload :Inspector, 'guard/cucumber/inspector'

    def run_all
      Runner.run ['features'], options.merge!({ :message => 'Run all Cucumber features' })
    end

    def run_on_change(paths)
      paths = Inspector.clean(paths)
      options.merge!({ :message => 'Run all Cucumber features' }) if paths.include?('features')
      Runner.run(paths, options) unless paths.empty?
    end

  end
end
