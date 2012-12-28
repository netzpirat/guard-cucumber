module Guard
  class Cucumber

    # The inspector verifies of the changed paths are valid
    # for Guard::Cucumber.
    #
    module Inspector
      class << self

        # Clean the changed paths and return only valid
        # Cucumber features.
        #
        # @param [Array<String>] paths the changed paths
        # @param [Array<String>] feature_sets the feature sets
        # @return [Array<String>] the valid feature files
        #
        def clean(paths, feature_sets)
          paths.uniq!
          paths.compact!
          paths = paths.select { |p| cucumber_file?(p, feature_sets) || cucumber_folder?(p, feature_sets) }
          paths = paths.delete_if { |p| included_in_other_path?(p, paths) }
          clear_cucumber_files_list
          paths
        end

        private

        # Tests if the file is the features folder.
        #
        # @param [String] path the file
        # @param [Array<String>] feature_sets the feature sets
        # @return [Boolean] when the file is the feature folder
        #
        def cucumber_folder?(path, feature_sets)
          path.match(/^\/?(#{ feature_sets.join('|') })/) && !path.match(/\..+$/)
        end

        # Tests if the file is valid.
        #
        # @param [String] path the file
        # @param [Array<String>] feature_sets the feature sets
        # @return [Boolean] when the file valid
        #
        def cucumber_file?(path, feature_sets)
          cucumber_files(feature_sets).include?(path.split(':').first)
        end

        # Scans the project and keeps a list of all
        # feature files in the `features` directory.
        #
        # @see #clear_jasmine_specs
        # @param [Array<String>] feature_sets the feature sets
        # @return [Array<String>] the valid files
        #
        def cucumber_files(feature_sets)
          @cucumber_files ||= Dir.glob("#{ feature_sets.join(',') }/**/*.feature")
        end

        # Clears the list of features in this project.
        #
        def clear_cucumber_files_list
          @cucumber_files = nil
        end

        # Checks if the given path is already contained
        # in the paths list.
        #
        # @param [Sting] path the path to test
        # @param [Array<String>] paths the list of paths
        #
        def included_in_other_path?(path, paths)
          paths = paths.select { |p| p != path }
          massaged = path[0...(path.index(':') || path.size)]
          paths.any? { |p| (path.include?(p) && (path.gsub(p, '')).include?('/')) || massaged.include?(p) }
        end
      end
    end
  end
end
