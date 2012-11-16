source :rubygems

gemspec

gem 'rake'

gem 'rspec'
gem 'guard-rspec'
gem 'yard'
gem 'redcarpet'

gem 'rb-inotify', :require => false
gem 'rb-fsevent', '~> 0.9.1'
gem 'rb-fchange', :require => false

group :test do
  gem "fakefs", :require => "fakefs/safe"
end

require 'rbconfig'

if RbConfig::CONFIG['target_os'] =~ /darwin/i
  gem 'ruby_gntp', :require => false
elsif RbConfig::CONFIG['target_os'] =~ /linux/i
  gem 'libnotify', :require => false
elsif RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i
  gem 'win32console', :require => false
  gem 'rb-notifu', :require => false
end
