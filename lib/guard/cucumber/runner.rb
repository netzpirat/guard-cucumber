module Guard
  class Cucumber

    # The Cucumber runner handles the execution of the cucumber binary.
    #
    module Runner
      class << self

        # Run the supplied features.
        #
        # @param [Array<String>] paths the feature files or directories
        # @param [Hash] options the options for the execution
        # @option options [Boolean] :bundler use bundler or not
        # @option options [Array<String>] :rvm a list of rvm version to use for the test
        # @option options [Boolean] :notification show notifications
        # @return [Boolean] the status of the execution
        #
        def run(paths, options = { })
          return false if paths.empty?

          message = options[:message] || (paths == ['features'] ? 'Run all Cucumber features' : "Run Cucumber features #{ paths.join(' ') }")
          UI.info message, :reset => true

          system(cucumber_command(paths, options))
        end

        private

        # Assembles the Cucumber command from the passed options.
        #
        # @param [Array<String>] paths the feature files or directories
        # @param [Hash] options the options for the execution
        # @option options [Boolean] :bundler use bundler or not
        # @option options [Array<String>] :rvm a list of rvm version to use for the test
        # @option options [Boolean] :notification show notifications
        # @return [String] the Cucumber command
        #
        def cucumber_command(paths, options)
          cmd = []
          cmd << "rvm #{options[:rvm].join(',')} exec" if options[:rvm].is_a?(Array)
          cmd << 'bundle exec' if (bundler? && options[:bundler] != false) || (bundler? && options[:binstubs].is_a?(TrueClass))
          cmd << cucumber_exec(options)
          cmd << options[:cli] if options[:cli]

          if options[:notification] != false
            notification_formatter_path = File.expand_path(File.join(File.dirname(__FILE__), 'notification_formatter.rb'))
            cmd << "--require #{ notification_formatter_path }"
            cmd << "--format Guard::Cucumber::NotificationFormatter"
            cmd << "--out #{ null_device }"
            cmd << "--require features"
          end

          (cmd + paths).join(' ')
        end

        # Simple test if binstubs prefix should be used.
        #
        # @return [String] Cucumber executable
        #
        def cucumber_exec(options = {})
            options[:binstubs] == true && ( bundler? || options[:bundler] != false ) ? "bin/cucumber" : "cucumber"
        end

        # Simple test if bundler should be used. it just checks for the `Gemfile`.
        #
        # @return [Boolean] bundler exists
        #
        def bundler?
          @bundler ||= File.exist?("#{Dir.pwd}/Gemfile")
        end

        # Returns a null device for all OS.
        #
        # @return [String] the name of the null device
        #
        def null_device
          RUBY_PLATFORM.index('mswin') ? 'NUL' : '/dev/null'
        end

      end
    end
  end
end
