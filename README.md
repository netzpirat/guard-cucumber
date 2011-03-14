# Guard::Cucumber

Guard::Cucumber allows you to automatically run Cucumber features when files are modified. It is tested on Ruby 1.8.7 & 1.9.2.

## Install

Please be sure to have [Guard](http://github.com/guard/guard) installed before continue.

Install the gem:

    gem install guard-cucumber

Add it to your `Gemfile`, preferably inside the test group:

    gem 'guard-cucumber'

Add Guard definition to your `Guardfile` by running this command:

    guard init cucumber

## Usage

Please read the [Guard usage documentation](http://github.com/guard/guard#readme).

## Guardfile

Guard::Cucumber can be adapted to all kind of projects. Please read the
[Guard documentation](http://github.com/guard/guard#readme) for more information about the Guardfile DSL.

    guard 'cucumber' do
      watch(%r{features/.+\.feature})
      watch(%r{features/support/.+})          { 'features' }
      watch(%r{features/step_definitions/.+}) { 'features' }
    end

## Options

There are several options you can pass to Guard::Cucumber to customize the arguments when calling Cucumber:

    :color => false                        # Disable colored output
    :drb => true                           # Enable Spork DRb server
    :port => 1234                          # Set custom Spork port
    :bundler => false                      # Don't use "bundle exec"
    :rvm => ['1.8.7', '1.9.2']             # Directly run your specs on multiple ruby
    :profile => 'cucumber_profile'         # Let cucumber use another profile than the default one
    :command => 'whatever'                 # Pass any other command to cucumber

## Development

- Source hosted at [GitHub](http://github.com/netzpirat/guard-cucumber)
- Report issues/Questions/Feature requests on [GitHub Issues](http://github.com/netzpirat/guard-cucumber/issues)

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
