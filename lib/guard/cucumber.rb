require 'guard'
require 'guard/guard'
require 'cucumber'

module Guard
  class Cucumber < Guard

    autoload :Runner, 'guard/cucumber/runner'
    autoload :Inspector, 'guard/cucumber/inspector'

    attr_reader :configuration, :runtime

    def start
      UI.info 'Preload cucumber environment. This could take a while...'

      @configuration = ::Cucumber::Cli::Configuration.new
      @runtime = ::Cucumber::Runtime.new(@configuration)
      @configuration.parse!(['features'])

      # Hack the support code, since loading the files takes most of the initialization time
      @support = ::Cucumber::Runtime::SupportCode.new(@runtime, @configuration)
      @support.load_files!(@configuration.support_to_load + @configuration.step_defs_to_load)
      @support.fire_hook(:after_configuration, @configuration)
      @runtime.instance_variable_set('@support_code', @support)

      UI.info 'Cucumber environment loaded.'
    end
    
    def run_all
      configuration.parse!(['features'])
      Runner.run runtime, configuration, options.merge!({ :message => 'Run all Cucumber features' })
    end

    def run_on_change(paths)
      paths = Inspector.clean(paths)
      options.merge!({ :message => 'Run all Cucumber features' }) if paths.include?('features')
      configuration.parse!(paths)
      Runner.run(runtime, configuration, options) unless paths.empty?
    end

  end
end
