require 'guard'
require 'guard/guard'

module Guard
  class Cucumber < Guard

    autoload :Runner, 'guard/cucumber/runner'
    autoload :Inspector, 'guard/cucumber/inspector'

    def run_all
      Runner.run ['features'], :message => 'Run all Cucumber features'
    end

    def run_on_change(paths)
      paths = Inspector.clean(paths)
      Runner.run(paths, options) unless paths.empty?
    end

  end
end
