require 'open3'

module Guard
  class Cucumber
    module Runner
      class << self
        include Open3

        def run(paths, options = {})
          message = options[:message] || run_message(paths)
          UI.info message, :reset => true

          status, message = execute_cucumber(paths)
          ::Guard::Notifier.notify(message, :title => 'Cucumber results', :image => (status == 0 ? :success : :failed))
        end

      private

        def execute_cucumber(paths)
          message = ''
          status = 0

          popen2e(cucumber_command(paths)) do |input, output, wait_thread|
            input.close
            while !output.eof?
              line = output.readline
              message << line if line =~ /^\d+ (steps|scenarios)/
              puts line
            end
            status = wait_thread.value
          end

          [status, message.gsub(/\[\d+m\d*?/, '')]
        end

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

        def run_message(paths)
          paths == ['features'] ? 'Run all Cucumber features' : "Run Cucumber feature#{ paths.size == 1 ? '' : 's' } #{ paths.join(' ') }"
        end

      end
    end
  end
end
