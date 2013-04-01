# Changelog

## 1.4.0 - Apr 1, 2013

- [#8][]: Don't require Bundler to use binstubs. ([@JeanMertz][])

## 1.3.2 - Jan 15, 2013

- Do not search focus tag in files that already have a line number on rerun.

## 1.3.1 - Jan 7, 2013

- [#7][]: Fix `run_all` with enabled focus option. ([@martco][])

## 1.3.0 - Dec 28, 2012

- [#6][]: Add `:focus_on` option. ([@martco][])

## 1.2.2 - Oct 31, 2012

- Add accessors for `last_failed` and `failed_path`

## 1.2.1 - Oct 31, 2012

- [#36][]: `:feature_sets` defined in Guardfile is not taken in account.

## 1.2.0 - June 19, 2012

- Add a command_prefix option. ([@mikefarmer][])

## 1.1.0 - June 6, 2012

- [#34][]: Implemented :feature_sets option. ([@andreassimon][])

## 1.0.0 - June 2, 2012

- Update for Guard 1.1

## 0.8.0 - Mai 8, 2012

- Update for Cucucmber 1.2.0

## 0.7.5 - Jan 17, 2012

- [#31][]: Allow to use binstubs. ([@dnagir][])
- [#27][]: Allow binstubs options. ([@hedgehog][])

## 0.7.4 - Nov 9, 2011

- [#24][]: Individual scenarios are no longer run if the entire feature is also scheduled to run([@oreoshake][])

## 0.7.3 - Oct 14, 2011

 - [#20][]: Close rerun.txt file properly after reading the failed features.

## 0.7.2 - Oct 1, 2011

- Enable :task_has_failed

## 0.7.1 - Oct 1, 2011

- Disable :task_has_failed until new Guard version is available.

## 0.7.0 - Sep 30, 2011

- Update for Guard 0.8

## 0.6.3 - Sep 8, 2011

- Documentation updates and refactorings.

## 0.6.2 - Sep 4, 2011

- [#17][]: Make sure either a valid symbol or nil is passed as image.

## 0.6.1 - Aug 17, 2011

- Remember line number of features to be rerun.

## 0.6.0 - Aug 14 2011

- Add `:run_all` option.

## 0.5.2 - Jul 04 2011

- [#13][]: Save failed features from `#run_all`. ([@lmarburger][])

## 0.5.1 - Jun 28 2011

- [#14][]: Ensure the Guard returns a boolean status.
- [#12][]: Require guard/notifier to fix exception in cucumber binary. ([@robertzx][])
- Introduces the `:change_format` option.
- [#11][] Add support for failure format. ([@NickClark][])

## 0.4.0 - Jun 06 2011

- Fix empty `rerun.txt`.

## 0.3.3 - Jun 06 2011

- Improve failed feature detection via `rerun.txt`.
- Change the :cli option to ignore the default profile.

## 0.3.1 - May 13 2011

- When stealing is desired: Porting the `:all_after_pass`, `:all_on_start` and `:keep_failed`
- Let Cucumber notify the most important story: a failure, else a pending, else an undefined. ([@lorennorman][])
- Added an extra Cucumber alert naming the failed steps. ([@lorennorman][])

## 0.3.0 - Mar 28 2011

- Cucumber arguments are now passed only through the CLI option.
- Use another null device on ms win.
- [#5][]: made loading of notification formatter as just another formatter with `/dev/null`. ([@hron][])

## 0.2.4 - Mar 14 2011

- Implemented workaround of not loaded step definitions when using guard-spork. ([@hron][])
- Added option to pass any command to cucumber. ([@oriolgual][])

## 0.2.3 - Jan 21 2011

- Add option to include a profile argument in cucumber. ([@thecatwasnot][])

## 0.2.2 - Dec 09 2010

- Depend on the latest cucumber 0.10.0

## 0.1.0 - Oct 28 2010

- Initial release.

[#5]: https://github.com/netzpirat/guard-cucumber/issues/5
[#6]: https://github.com/guard/guard-cucumber/issues/6
[#7]: https://github.com/guard/guard-cucumber/issues/7
[#8]: https://github.com/guard/guard-cucumber/issues/8
[#11]: https://github.com/netzpirat/guard-cucumber/issues/11
[#12]: https://github.com/netzpirat/guard-cucumber/issues/12
[#13]: https://github.com/netzpirat/guard-cucumber/issues/13
[#14]: https://github.com/netzpirat/guard-cucumber/issues/14
[#17]: https://github.com/netzpirat/guard-cucumber/issues/17
[#20]: https://github.com/netzpirat/guard-cucumber/issues/20
[#24]: https://github.com/netzpirat/guard-cucumber/issues/24
[#27]: https://github.com/netzpirat/guard-cucumber/issues/27
[#31]: https://github.com/netzpirat/guard-cucumber/issues/31
[#34]: https://github.com/netzpirat/guard-cucumber/issues/34
[#36]: https://github.com/netzpirat/guard-cucumber/issues/36
[@NickClark]: https://github.com/NickClark
[@andreassimon]: https://github.com/andreassimon
[@dnagir]: https://github.com/dnagir
[@hedgehog]: https://github.com/hedgehog
[@hron]: https://github.com/hron
[@JeanMertz]: https://github.com/JeanMertz
[@lmarburger]: https://github.com/lmarburger
[@lorennorman]: https://github.com/lorennorman
[@martco]: https://github.com/martco
[@mikefarmer]: https://github.com/mikefarmer
[@oreoshake]: https://github.com/oreoshake
[@oriolgual]: https://github.com/oriolgual
[@robertzx]: https://github.com/robertzx
[@thecatwasnot]: https://github.com/thecatwasnot
