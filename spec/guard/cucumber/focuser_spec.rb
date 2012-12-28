require 'spec_helper'
require 'fakefs/spec_helpers'

describe Guard::Cucumber::Focuser do
  include FakeFS::SpecHelpers

  let(:focuser)     { Guard::Cucumber::Focuser }
  let(:focus_tag)   { '@focus' }
  let(:null_device) { RUBY_PLATFORM.index('mswin') ? 'NUL' : '/dev/null' }

  let(:dir)       { 'features' }
  let(:path)      { 'foo.feature' }
  let(:path_two)  { 'bar.feature' }

  describe '#focus' do
    context 'when passed an empty paths list' do
      it 'returns false' do
        focuser.focus([], '@focus').should be_false
      end
    end

    context 'when passed a paths argument' do
      before do
        File.open(path, 'w') do |f|
          f.write "@focus\nScenario: Foo\n\tGiven bar\n"
          f.write "Scenario: Bar\n\tGiven lorem\n"
          f.write "@focus\nScenario: Ipsum\n\tGiven dolor"
        end
        File.open(path_two, 'w') do |f|
          f.write "@focus\nScenario: Lorem\n\tGiven ipsum\n"
          f.write "@focus\nScenario: Bar\n\tGiven lorem\n"
          f.write "Scenario: Dolor\n\tGiven sit\n"
        end
      end

      it 'returns an array of paths updated to focus on line numbers' do
        paths = [path, path_two]

        focuser.focus(paths, focus_tag).should eq([
          'foo.feature:1:6',
          'bar.feature:1:4'
        ])
      end
    end
  end

  describe '#scan_path_for_focus_tag' do
    context 'file with focus tags in it' do
      before do
        File.open(path, 'w') do |f|
          f.write "@focus\nScenario: Foo\n\tGiven bar\n"
          f.write "Scenario: Bar\n\tGiven lorem\n"
          f.write "@focus\nScenario: Ipsum\n\tGiven dolor"
        end
      end

      it 'returns an array of line numbers' do
        focuser.scan_path_for_focus_tag(path, focus_tag).should eq([1, 6])
      end
    end

    context 'file without focus tags in it' do
      before do
        File.open(path, 'w') do |f|
          f.write "Scenario: Foo\n\tGiven bar"
          f.write "\nScenario: Bar\n\tGiven lorem"
          f.write "\nScenario: Ipsum\n\tGiven dolor"
        end
      end

      it 'returns an empty array' do
        focuser.scan_path_for_focus_tag(path, focus_tag).should eq([])
      end
    end
  end

  describe '#append_line_numbers_to_path' do
    it 'returns a path with line numbers appended' do
      line_numbers = [1,2]
      returned_path = focuser.append_line_numbers_to_path(line_numbers, path)
      returned_path.should eq(path + ':1:2')
    end
  end
end

