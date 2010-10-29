require 'cucumber'
require 'guard/cucumber/cucumber_formatter'

module Guard
  class Cucumber
    module Runner
      class << self

        def run(runtime, configuration, options = {})
          features = configuration.feature_files
          message = options[:message] || run_message(features)
          UI.info message, :reset => true

          run_cucumber(features, runtime, configuration)
        end

      private

        def run_cucumber(features, runtime, configuration)
          formatter = CucumberFormatter.new(runtime, $stdout, configuration.instance_variable_get('@options'))
          runner = ::Cucumber::Ast::TreeWalker.new(runtime, [formatter], configuration)
          runtime.visitor = runner
          loader = ::Cucumber::Runtime::FeaturesLoader.new(features, configuration.filters, configuration.tag_expression)
          runner.visit_features(loader.features)
        end

        def run_message(paths)
          paths == ['features'] ? 'Run all Cucumber features' : "Run Cucumber feature#{ paths.size == 1 ? '' : 's' } #{ paths.join(' ') }"
        end

      end
    end
  end
end
