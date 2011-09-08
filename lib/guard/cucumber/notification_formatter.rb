require 'guard'
require 'guard/notifier'
require 'cucumber/formatter/console'
require 'cucumber/formatter/io'

module Guard
  class Cucumber

    # The notification formatter is a Cucumber formatter that Guard::Cucumber
    # passes to the Cucumber binary. It writes the `rerun.txt` file with the failed features
    # an creates system notifications.
    #
    # @see https://github.com/cucumber/cucumber/wiki/Custom-Formatters
    #
    class NotificationFormatter
      include ::Cucumber::Formatter::Console

      attr_reader :step_mother

      # Initialize the formatter.
      #
      # @param [Cucumber::Runtime] step_mother the step mother
      # @param [String, IO] path_or_io the path or IO to the feature file
      # @param [Hash] options the options
      #
      def initialize(step_mother, path_or_io, options)
        @options = options
        @file_names = []
        @step_mother = step_mother
      end

      # Notification after all features have completed.
      #
      # @param [Array[Cucumber::Ast::Feature]] features the ran features
      #
      def after_features(features)
        notify_summary
        write_rerun_features if !@file_names.empty?
      end

      # Before a feature gets run.
      #
      # @param [Cucumber::Ast::FeatureElement] feature_element
      #
      def before_feature_element(feature_element)
        @rerun = false
        @feature_name = feature_element.name
      end

      # After a feature gets run.
      #
      # @param [Cucumber::Ast::FeatureElement] feature_element
      #
      def after_feature_element(feature_element)
        if @rerun
          @file_names << feature_element.file_colon_line
          @rerun = false
        end
      end

      # Gets called when a step is done.
      #
      # @param [String] keyword the keyword
      # @param [Cucumber::StepMatch] step_match the step match
      # @param [Symbol] status the status of the step
      # @param [Integer] source_indent the source indentation
      # @param [Cucumber::Ast::Background] background the feature background
      #
      def step_name(keyword, step_match, status, source_indent, background)
        if [:failed, :pending, :undefined].index(status)
          @rerun = true
          step_name = step_match.format_args(lambda { |param| "*#{ param }*" })

          ::Guard::Notifier.notify step_name, :title => @feature_name, :image => icon_for(status)
        end
      end

      private

      # Notify the user with a system notification about the
      # result of the feature tests.
      #
      def notify_summary
        icon, messages = nil, []

        [:failed, :skipped, :undefined, :pending, :passed].reverse.each do |status|
          if step_mother.steps(status).any?
            step_icon = icon_for(status)
            icon = step_icon if step_icon
            messages << dump_count(step_mother.steps(status).length, 'step', status.to_s)
          end
        end

        ::Guard::Notifier.notify messages.reverse.join(', '), :title => 'Cucumber Results', :image => icon
      end

      # Writes the `rerun.txt` file containing all failed features.
      #
      def write_rerun_features
        File.open('rerun.txt', 'w') do |f|
          f.puts @file_names.join(' ')
        end
      end

      # Gives the icon name to use for the status.
      #
      # @param [Symbol] status the cucumber status
      # @return [Symbol] the Guard notification symbol
      #
      def icon_for(status)
        case status
          when :passed
            :success
          when :pending, :undefined, :skipped
            :pending
          when :failed
            :failed
          else
            nil
        end
      end

    end
  end
end
