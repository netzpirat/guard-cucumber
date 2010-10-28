require 'open3'

module Guard
  class Cucumber
    module Runner
      class << self
        include Open3

        def run(paths, options = {})
          message = options[:message] || (paths == ['features'] ? 'Run all Cucumber features' : "Run Cucumber features #{ paths.join(' ') }")
          UI.info message, :reset => true

          growl = ''
          popen2e(cucumber_command(paths)) do |input, output|
            input.close
            while !output.eof?
              line = output.readline
              growl << line if line =~ /^\d+ (steps|scenarios)/
              puts line
            end
          end

          ::Guard::Notifier.notify(growl.gsub(/\[\d+m\d*?/, ''), :title => 'Cucumber results', :image => ($? == 0 ? :success : :failed))
        end

      private

        def cucumber_command(paths)
          cmd = []
          cmd << 'bundle exec' if bundler?
          cmd << 'cucumber'
          cmd << '--color'
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
