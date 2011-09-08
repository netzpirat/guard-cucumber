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
        # @return [Array<String>] the valid feature files
        #
        def clean(paths)
          paths.uniq!
          paths.compact!
          paths = paths.select { |p| cucumber_file?(p) || cucumber_folder?(p) }
          paths = paths.delete_if { |p| included_in_other_path?(p, paths) }
          clear_cucumber_files_list
          paths
        end

        private

        # Tests if the file is the features folder.
        #
        # @param [String] file the file
        # @return [Boolean] when the file is the feature folder
        #
        def cucumber_folder?(path)
          path.match(/^\/?features/) && !path.match(/\..+$/)
        end

        # Tests if the file is valid.
        #
        # @param [String] file the file
        # @return [Boolean] when the file valid
        #
        def cucumber_file?(path)
          cucumber_files.include?(path.split(':').first)
        end

        # Scans the project and keeps a list of all
        # feature files in the `features` directory.
        #
        # @see #clear_jasmine_specs
        # @return [Array<String>] the valid files
        #
        def cucumber_files
          @cucumber_files ||= Dir.glob('features/**/*.feature')
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
          paths.any? { |p| path.include?(p) && (path.gsub(p, '')).include?('/') }
        end

      end
    end
  end
end
