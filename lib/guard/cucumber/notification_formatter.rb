require 'guard'
require 'guard/notifier'
require 'cucumber/formatter/console'
require 'cucumber/formatter/io'

module Guard
  class Cucumber
    class NotificationFormatter
      include ::Cucumber::Formatter::Console

      attr_reader :step_mother

      def initialize(step_mother, path_or_io, options)
        @options = options
        @file_names = []
        @step_mother = step_mother
      end

      def after_features(features)
        notify_summary
        write_rerun_features if !@file_names.empty?
      end

      def before_feature_element(feature_element)
        @rerun = false
        @feature_name = feature_element.name
      end

      def after_feature_element(feature_element)
        if @rerun
          @file_names << *feature_element.file_colon_line
        end
      end

      def step_name(keyword, step_match, status, source_indent, background)
        if [:failed, :pending, :undefined].index(status)
          @rerun = true
          step_name = step_match.format_args(lambda { |param| "*#{ param }*" })
          ::Guard::Notifier.notify step_name, :title => @feature_name, :image => icon_for(status)
        else
          @rerun = false
        end
      end

      private

      def notify_summary
        icon, messages = '', []

        [:failed, :skipped, :undefined, :pending, :passed].reverse.each do |status|
          if step_mother.steps(status).any?
            icon = icon_for(status)
            messages << dump_count(step_mother.steps(status).length, 'step', status.to_s)
          end
        end

        ::Guard::Notifier.notify messages.reverse.join(', '), :title => 'Cucumber Results', :image => icon
      end

      def write_rerun_features
        File.open('rerun.txt', 'w') do |f|
          f.puts @file_names.join(' ')
        end
      end

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
