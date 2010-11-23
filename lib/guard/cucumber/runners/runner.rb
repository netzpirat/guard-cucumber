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
          cmd << "--profile #{options[:profile]}" if options[:profile]
          cmd << "--require #{ File.expand_path(File.join(File.dirname(__FILE__), '..', 'cucumber_formatter.rb')) } --format CucumberFormatter"
          cmd << '--color' if options[:color] != false
          cmd << "--drb" if options[:drb]
          cmd << "--port #{ options[:port] }" if options[:port] && options[:drb]
          cmd << "--require features"
          cmd << options[:command] if options[:command]
          cmd = cmd + paths
          cmd.join(' ')
        end

        def bundler?
          @bundler ||= File.exist?("#{Dir.pwd}/Gemfile")
        end
      end
    end
  end
end

