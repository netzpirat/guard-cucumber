# Guard::Cucumber

![travis-ci](http://travis-ci.org/netzpirat/guard-cucumber.png)

Guard::Cucumber allows you to automatically run Cucumber features when files are modified.

Tested on MRI Ruby 1.8.6, 1.8.7, 1.9.2 and the latest versions of JRuby & Rubinius.

## Install

Please be sure to have [Guard](https://github.com/guard/guard) installed before continue.

Install the gem:

    gem install guard-cucumber

Add it to your `Gemfile`, preferably inside the test group:

    gem 'guard-cucumber'

Add the default Guard::Cucumber template to your `Guardfile` by running this command:

    guard init cucumber

## Usage

Please read the [Guard usage documentation](https://github.com/guard/guard#readme).

## Guardfile

Guard::Cucumber can be adapted to all kind of projects and comes with a default template that looks like this:

    guard 'cucumber' do
      watch(%r{features/.+\.feature})
      watch(%r{features/support/.+})                      { 'features' }
      watch(%r{features/step_definitions/(.+)_steps\.rb}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
    end

Expressed in plain English, this configuration tells Guard::Cucumber:

1. When a file within the features directory that ends in feature is modified, just run that single feature.
2. When any file within features/support directory is modified, run all features.
3. When a file within the features/step_definitions directory that ends in \_steps.rb is modified,
run the first feature that matches the name (\_steps.rb replaced by .feature) and when no feature is found,
then run all features.

Please read the [Guard documentation](http://github.com/guard/guard#readme) for more information about the Guardfile DSL.

## Options

You can pass any of the standard Cucumber CLI options using the :cli option:

    guard 'cucumber', :cli => '-c --drb --port 1234 --profile custom' do
      ...
    end

Former `:color`, `:drb`, `:port` and `:profile` options are thus deprecated and have no effect anymore.

### List of available options

    :cli => '-c -f pretty'            # Pass arbitrary Cucumber CLI arguments, default: nil
    :bundler => false                 # Don't use "bundle exec" to run the Cucumber command, default: true
    :rvm => ['1.8.7', '1.9.2']        # Directly run your features on multiple ruby versions, default: nil
    :notification => false            # Don't display Growl (or Libnotify) notification, default: true

## Spork configuration

To use Guard::Cucumber with [Spork](https://github.com/timcharper/spork) (preferabbly managed through
[Guard::Spork](https://github.com/guard/guard-spork)), you'll want to use the following configuration:

    guard 'cucumber', :cli => '--drb --require features/support --require features/step_definitions' do
      ...
    end

## Development

- Source hosted at [GitHub](https://github.com/netzpirat/guard-cucumber)
- Report issues/Questions/Feature requests on [GitHub Issues](https://github.com/netzpirat/guard-cucumber/issues)

Pull requests are very welcome! Make sure your patches are well tested.

## Contributors

* [Oriol Gual](https://github.com/oriolgual)
* [Aleksei Gusev](https://github.com/hron)

## Acknowledgment

The [Guard Team](https://github.com/guard/guard/contributors) for giving us such a nice pice of software
that is so easy to extend, one *has* to make a plugin for it!

All the authors of the numerous [Guards](http://github.com/guard) avaiable for making the Guard ecosystem
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
