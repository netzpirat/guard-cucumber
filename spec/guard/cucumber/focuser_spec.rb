require 'spec_helper'

describe Guard::Cucumber::Focuser do

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
      let(:file) do
        StringIO.new <<-EOS
          @focus
          Scenario: Foo
          Given bar
          Scenario: Bar
          Given lorem
          @focus
          Scenario: Ipsum
          Given dolor
        EOS
      end

      let(:file_two) do
        StringIO.new <<-EOS
          @focus
          Scenario: Lorem
          Given ipsum
          @focus
          Scenario: Bar
          Given lorem
          Scenario: Dolor
          Given sit
        EOS
      end

      before do
        File.should_receive(:open).with(path, 'r').and_yield(file)
        File.should_receive(:open).with(path_two, 'r').and_yield(file_two)
      end

      it 'returns an array of paths updated to focus on line numbers' do
        paths = [path, path_two]

        focuser.focus(paths, focus_tag).should eql([
          'foo.feature:1:6',
          'bar.feature:1:4'
        ])
      end
    end
  end

  describe '#scan_path_for_focus_tag' do
    context 'file with focus tags in it' do
      let(:file) do
        StringIO.new <<-EOS
          @focus
          Scenario: Foo
          Given bar
          Scenario: Bar
          Given lorem
          @focus
          Scenario: Ipsum
          Given dolor
        EOS
      end

      before do
        File.should_receive(:open).with(path, 'r').and_yield(file)
      end

      it 'returns an array of line numbers' do
        focuser.scan_path_for_focus_tag(path, focus_tag).should eql([1, 6])
      end
    end

    context 'file without focus tags in it' do
      let(:file) do
        StringIO.new <<-EOS
          Scenario: Foo
          Given bar
          Scenario: Bar
          Given lorem
          Scenario: Ipsum
          Given dolor
        EOS
      end

      before do
        File.should_receive(:open).with(path, 'r').and_return(file)
      end

      it 'returns an empty array' do
        focuser.scan_path_for_focus_tag(path, focus_tag).should eql([])
      end
    end
  end

  describe '#append_line_numbers_to_path' do
    it 'returns a path with line numbers appended' do
      line_numbers = [1,2]
      returned_path = focuser.append_line_numbers_to_path(line_numbers, path)
      returned_path.should eql(path + ':1:2')
    end
  end
end

