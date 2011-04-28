require 'guard'
require 'cucumber/formatter/console'

module Guard
  class Cucumber
    class NotificationFormatter
      include ::Cucumber::Formatter::Console

      attr_reader :step_mother

      def initialize(step_mother, path_or_io, options)
        @step_mother = step_mother
      end

      def after_features(features)
        icon, messages = '', []

        # summary of the run
        [:failed, :skipped, :undefined, :pending, :passed].reverse.each do |status|
          if step_mother.steps(status).any?
            icon = icon_for(status)
            messages << dump_count(step_mother.steps(status).length, 'step', status.to_s)
          end
        end

        ::Guard::Notifier.notify messages.reverse.join(', '), :title => 'Cucumber Results', :image => icon

        # details about failures, what to work on
        [:failed, :pending, :undefined].each do |status|
          if step_mother.steps(status).any?
            icon = icon_for(status)
            step_mother.steps(status).each do |step|
              ::Guard::Notifier.notify step.name, :title => "#{status} steps", :image => icon
            end

            break
          end
        end
      end

      private

      def icon_for(status)
        case status
        when :passed
          :success
        when :pending, :undefined, :skipped
          :pending
        when :failed
          :failed
        end
      end

    end

  end

end
