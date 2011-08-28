# Guard::Cucumber

![travis-ci](http://travis-ci.org/netzpirat/guard-cucumber.png)

Guard::Cucumber allows you to automatically run Cucumber features when files are modified.

Tested on MRI Ruby 1.8.7, 1.9.2 and the latest versions of JRuby & Rubinius.

If you have any questions please join us on our [Google group](http://groups.google.com/group/guard-dev) or on `#guard` (irc.freenode.net).

## Install

Please be sure to have [Guard](https://github.com/guard/guard) installed before continue.

Install the gem:

```bash
$ gem install guard-cucumber
```

Add it to your `Gemfile`, preferably inside the test group:

```ruby
gem 'guard-cucumber'
```

Add the default Guard::Cucumber template to your `Guardfile` by running this command:

```bash
$ guard init cucumber
```

## Usage

Please read the [Guard usage documentation](https://github.com/guard/guard#readme).

## Guardfile

Guard::Cucumber can be adapted to all kind of projects and comes with a default template that looks like this:

```ruby
guard 'cucumber' do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})                      { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
end
```

Expressed in plain English, this configuration tells Guard::Cucumber:

1. When a file within the features directory that ends in feature is modified, just run that single feature.
2. When any file within features/support directory is modified, run all features.
3. When a file within the features/step_definitions directory that ends in \_steps.rb is modified,
run the first feature that matches the name (\_steps.rb replaced by .feature) and when no feature is found,
then run all features.

Please read the [Guard documentation](http://github.com/guard/guard#readme) for more information about the Guardfile DSL.

## Options

You can pass any of the standard Cucumber CLI options using the :cli option:

```ruby
guard 'cucumber', :cli => '-c --drb --port 1234 --profile guard' do
end
```

Former `:color`, `:drb`, `:port` and `:profile` options are thus deprecated and have no effect anymore.

### List of available options

```ruby
:cli => '--profile guard -c'      # Pass arbitrary Cucumber CLI arguments, 
                                  # default: '--no-profile --color --format progress --strict'

:bundler => false                 # Don't use "bundle exec" to run the Cucumber command
                                  # default: true

:rvm => ['1.8.7', '1.9.2']        # Directly run your features on multiple ruby versions
                                  # default: nil

:notification => false            # Don't display Growl (or Libnotify) notification
                                  # default: true

:all_after_pass => false          # Don't run all features after changed features pass
                                  # default: true

:all_on_start => false            # Don't run all the features at startup
                                  # default: true

:keep_failed => false             # Keep failed features until them pass
                                  # default: true

:run_all => { :cli => "-p" }      # Override any option when running all specs
                                  # default: {}

:change_format => 'pretty'        # Use a different cucumber format when running individual features
                                  # This replaces the Cucumber --format option within the :cli option
                                  # default: nil
```

## Cucumber configuration

It's **very important** that you understand how Cucumber gets configured, because it's often the origin of
strange behavior of guard-cucumber.

Cucumber uses [cucumber.yml](https://github.com/cucumber/cucumber/wiki/cucumber.yml) for defining profiles
of specific run configurations. When you pass configurations through the `:cli` option but don't include a
specific profile with `--profile`, then the configurations from the `default` profile are also used.

For example, when you're using the default cucumber.yml generated by [cucumber-rails](https://github.com/cucumber/cucumber-rails),
then the default profile forces guard-cucumber to always run all features, because it appends the `features` folder.

### Configure Cucumber solely from Guard

If you want to configure Cucumber from Guard solely, then you should pass `--no-profile` to the `:cli` option.

Since guard-cucumber version 0.3.2, the default `:cli` options are:

```ruby
:cli => '--no-profile --color --format progress --strict'
```

This default configuration has been chosen to avoid strange behavior when mixing configurations form
the cucumber.yml default profile with the guard-cucumber `:cli` option.

You can safely remove `config/cucumber.yml`, since all configuration is done in the `Guardfile`.

### Use a separate Guard profile

If you're using different profiles with Cucumber then you should create a profile for Guard in cucumber.yml,
something like this:

```
guard: --format progress --strict --tags ~@wip
```

Now you want to make guard-cucumber use that profile by passing '--profile guard' to the `:cli`.

## Cucumber with Spork

To use Guard::Cucumber with [Spork](https://github.com/timcharper/spork), you should install
[Guard::Spork](https://github.com/guard/guard-spork) and use the following configuration:

```ruby
guard 'spork' do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.*\.rb$})
  watch(%r{^config/initializers/.*\.rb$})
  watch('spec/spec_helper.rb')
end

guard 'cucumber', :cli => '--drb --format progress --no-profile' do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})                      { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
end
```

There is a section with alternative configurations on the [Wiki](https://github.com/netzpirat/guard-cucumber/wiki/Spork-configurations).

## Development

- Source hosted at [GitHub](https://github.com/netzpirat/guard-cucumber)
- Report issues and feature requests to [GitHub Issues](https://github.com/netzpirat/guard-cucumber/issues)

Pull requests are very welcome! Make sure your patches are well tested.

For questions please join us on our [Google group](http://groups.google.com/group/guard-dev) or on `#guard` (irc.freenode.net).

## Contributors

* [Aleksei Gusev](https://github.com/hron)
* [Larry Marburger](https://github.com/lmarburger)
* [Loren Norman](https://github.com/lorennorman)
* [Nicholas A Clark](https://github.com/NickClark)
* [Oriol Gual](https://github.com/oriolgual)
* [Robert Sanders](https://github.com/robertzx)

Since guard-cucumber is very close to guard-rspec, some contributions by the following authors have been
incorporated into guard-cucumber:

* [Andre Arko](https://github.com/indirect)
* [Thibaud Guillaume-Gentil](https://github.com/thibaudgg)

## Acknowledgment

The [Guard Team](https://github.com/guard/guard/contributors) for giving us such a nice pice of software
that is so easy to extend, one *has* to make a plugin for it!

All the authors of the numerous [Guards](http://github.com/guard) available for making the Guard ecosystem
so much growing and comprehensive.

## License

(The MIT License)

Copyright (c) 2010 - 2011 Michael Kessler

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
