require 'cucumber/formatter/progress'

class CucumberFormatter < Cucumber::Formatter::Progress

  def print_stats(features, profiles = [])
    super features, profiles

    icon, messages = '', []
    [:failed, :skipped, :undefined, :pending, :passed].reverse.each do |status|
      if step_mother.steps(status).any?
        icon = icon_for(status)
        messages << dump_count(step_mother.steps(status).length, 'step', status.to_s)
      end
    end

    ::Guard::Notifier.notify messages.reverse.join(', '), :title => 'Cucumber Results', :image => icon
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