require 'spec_helper'

describe Guard::Cucumber::Inspector do
  before do
    Dir.stub(:glob).and_return ['features/a.feature', 'features/subfolder/b.feature']
  end

  subject { Guard::Cucumber::Inspector }

  describe '.clean' do
    it 'removes non-feature files' do
      subject.clean(['features/a.feature', 'b.rb']).should == ['features/a.feature']
    end

    it 'removes non-existing feature files' do
      subject.clean(['features/a.feature', 'features/x.feature']).should == ['features/a.feature']
    end

    it 'keeps a feature folder' do
      subject.clean(['features/a.feature', 'features/subfolder']).should == ['features/a.feature', 'features/subfolder']
    end

    it 'removes duplicate paths' do
      subject.clean(['features', 'features']).should == ['features']
    end

    it 'removes feature folders included in other feature folders' do
      subject.clean(['features/subfolder', 'features']).should == ['features']
    end

    it 'removes feature files includes in feature folder' do
      subject.clean(['features/subfolder/b.feature', 'features']).should == ['features']
    end
  end
end
