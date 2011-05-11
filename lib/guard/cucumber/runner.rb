module Guard
  class Cucumber
    module Runner
      class << self

        def run(paths, options = {})
          message = options[:message] || (paths == ['features'] ? 'Run all Cucumber features' : "Run Cucumber features #{ paths.join(' ') }")
          UI.info message, :reset => true
          system(cucumber_command(paths, options))
        end

        private

        def cucumber_command(paths, options)
          cmd = []
          cmd << "rvm #{options[:rvm].join(',')} exec" if options[:rvm].is_a?(Array)
          cmd << 'bundle exec' if bundler? && options[:bundler] != false

          cmd << 'cucumber'
          cmd << options[:cli] if options[:cli]

          if options[:notification] != false
            cmd << "--require #{ File.expand_path(File.join(File.dirname(__FILE__), 'notification_formatter.rb')) } --format Guard::Cucumber::NotificationFormatter --out #{ null_device }"
            cmd << "--require features"
          end

          (cmd + paths).join(' ')
        end

        def bundler?
          @bundler ||= File.exist?("#{Dir.pwd}/Gemfile")
        end

        def null_device
          RUBY_PLATFORM.index('mswin') ? 'NUL' : '/dev/null'
        end

      end
    end
  end
end
