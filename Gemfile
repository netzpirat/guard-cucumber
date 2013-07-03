source "https://rubygems.org"

gemspec

gem 'rake'
gem 'rspec'

# The development group will no be
# installed on Travis CI.
#
group :development do
  gem 'guard-rspec'
  gem 'yard'
  gem 'redcarpet'

  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false

  require 'rbconfig'

  if RbConfig::CONFIG['target_os'] =~ /darwin/i
    gem 'ruby_gntp', :require => false
  elsif RbConfig::CONFIG['target_os'] =~ /linux/i
    gem 'libnotify', :require => false
  elsif RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i
    gem 'win32console', :require => false
    gem 'rb-notifu', :require => false
  end
end
