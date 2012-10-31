require 'spec_helper'

describe Guard::Cucumber::Inspector do

  let(:inspector) { Guard::Cucumber::Inspector }

  describe '.clean' do
    context 'with the standard feature set' do
      before do
        Dir.stub(:glob).and_return %w(features/a.feature features/subfolder/b.feature)
      end

      it 'removes non-feature files' do
        inspector.clean(%w(features/a.feature b.rb), %w(features)).should == %w(features/a.feature)
      end

      it 'removes non-existing feature files' do
        inspector.clean(%w(features/a.feature features/x.feature), %w(features)).should == %w(features/a.feature)
      end

      it 'keeps a feature folder' do
        inspector.clean(%w(features/a.feature features/subfolder), %w(features)).should == %w(features/a.feature features/subfolder)
      end

      it 'removes duplicate paths' do
        inspector.clean(%w(features features), %w(features)).should == %w(features)
      end

      it 'removes individual feature tests if the path is already in paths to run' do
        inspector.clean(%w(features/a.feature features/a.feature:10), %w(features)).should == %w(features/a.feature)
      end

      it 'removes feature folders included in other feature folders' do
        inspector.clean(%w(features/subfolder features), %w(features)).should == %w(features)
      end

      it 'removes feature files includes in feature folder' do
        inspector.clean(%w(features/subfolder/b.feature features), %w(features)).should == %w(features)
      end
    end

    context 'with an additional feature set' do
      before do
        Dir.stub(:glob).and_return %w(feature_set_1/a.feature feature_set_1/subfolder/b.feature feature_set_2/c.feature feature_set_2/subfolder/d.feature)
      end

      it 'removes non-feature files' do
        inspector.clean(%w(feature_set_1/a.feature feature_set_2/c.feature b.rb), %w(feature_set_1, feature_set_2)).should == %w(feature_set_1/a.feature feature_set_2/c.feature)
      end

      it 'removes non-existing feature files' do
        inspector.clean(%w(feature_set_1/a.feature feature_set_1/x.feature feature_set_2/c.feature feature_set_2/y.feature), %w(feature_set_1 feature_set_2)).should == %w(feature_set_1/a.feature feature_set_2/c.feature)
      end

      it 'keeps the feature folders' do
        inspector.clean(%w(feature_set_1/a.feature feature_set_1/subfolder feature_set_2/c.feature feature_set_2/subfolder), %w(feature_set_1 feature_set_2)).should == %w(feature_set_1/a.feature feature_set_1/subfolder feature_set_2/c.feature feature_set_2/subfolder)
      end

      it 'removes duplicate paths' do
        inspector.clean(%w(feature_set_1 feature_set_1 feature_set_2 feature_set_2), %w(feature_set_1 feature_set_2)).should == %w(feature_set_1 feature_set_2)
      end

      it 'removes individual feature tests if the path is already in paths to run' do
        inspector.clean(%w(feature_set_1/a.feature feature_set_1/a.feature:10 feature_set_2/c.feature feature_set_2/c.feature:25), %w(features feature_set_2)).should == %w(feature_set_1/a.feature feature_set_2/c.feature)
      end

      it 'removes feature folders included in other feature folders' do
        inspector.clean(%w(feature_set_1/subfolder feature_set_1 feature_set_2/subfolder feature_set_2), %w(feature_set_1 feature_set_2)).should == %w(feature_set_1 feature_set_2)
        inspector.clean(%w(feature_set_1 feature_set_2/subfolder), %w(feature_set_1 feature_set_2)).should == %w(feature_set_1 feature_set_2/subfolder)
        inspector.clean(%w(feature_set_2 feature_set_1/subfolder), %w(feature_set_1 feature_set_2)).should == %w(feature_set_2 feature_set_1/subfolder)
      end

      it 'removes feature files includes in feature folder' do
        inspector.clean(%w(feature_set_1/subfolder/b.feature feature_set_1 feature_set_2/subfolder/c.feature feature_set_2), %w(feature_set_1 feature_set_2)).should == %w(feature_set_1 feature_set_2)
        inspector.clean(%w(feature_set_1/subfolder/b.feature feature_set_2), %w(feature_set_1 feature_set_2)).should == %w(feature_set_1/subfolder/b.feature feature_set_2)
        inspector.clean(%w(feature_set_2/subfolder/d.feature feature_set_1), %w(feature_set_1 feature_set_2)).should == %w(feature_set_2/subfolder/d.feature feature_set_1)
      end
    end
  end
end
