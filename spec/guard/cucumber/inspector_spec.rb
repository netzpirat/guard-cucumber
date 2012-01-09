require 'spec_helper'

describe Guard::Cucumber::Inspector do

  let(:inspector) { Guard::Cucumber::Inspector }

  before do
    Dir.stub(:glob).and_return ['features/a.feature', 'features/subfolder/b.feature']
  end

  describe '.clean' do
    it 'removes non-feature files' do
      inspector.clean(['features/a.feature', 'b.rb']).should == ['features/a.feature']
    end

    it 'removes non-existing feature files' do
      inspector.clean(['features/a.feature', 'features/x.feature']).should == ['features/a.feature']
    end

    it 'keeps a feature folder' do
      inspector.clean(['features/a.feature', 'features/subfolder']).should == ['features/a.feature',
                                                                               'features/subfolder']
    end

    it 'removes duplicate paths' do
      inspector.clean(['features', 'features']).should == ['features']
    end

    it 'removes feature folders included in other feature folders' do
      inspector.clean(['features/subfolder', 'features']).should == ['features']
    end

    it 'removes feature files includes in feature folder' do
      inspector.clean(['features/subfolder/b.feature', 'features']).should == ['features']
    end
  end
end
