require 'cucumber'
require 'cucumber/formatter/progress'
require 'guard/cucumber/notification_formatter'

module Guard
  class Cucumber
    module PreloadRunner
      class << self
        def start
          UI.info '*** WARNING: Preload the Cucumber environment is known to have some issues with class reloading'
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

        def run(paths, options = {})
          @configuration.parse!(paths)
          features = @configuration.feature_files
          message = options[:message] || run_message(features)
          UI.info message, :reset => true

          formatters = [
            NotificationFormatter.new(@runtime, $stdout, @configuration.instance_variable_get('@options')),
            ::Cucumber::Formatter::Progress.new(@runtime, $stdout, @configuration.instance_variable_get('@options'))
          ]
          runner = ::Cucumber::Ast::TreeWalker.new(@runtime, formatters, @configuration)
          @runtime.visitor = runner
          loader = ::Cucumber::Runtime::FeaturesLoader.new(features, @configuration.filters, @configuration.tag_expression)
          runner.visit_features(loader.features)
        end

        private

        def run_message(paths)
          paths == ['features'] ? 'Run all Cucumber features' : "Run Cucumber feature#{ paths.size == 1 ? '' : 's' } #{ paths.join(' ') }"
        end

      end
    end
  end
end
