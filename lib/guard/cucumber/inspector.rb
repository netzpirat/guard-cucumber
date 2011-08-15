module Guard
  class Cucumber
    module Inspector
      class << self

        def clean(paths)
          paths.uniq!
          paths.compact!
          paths = paths.select { |p| cucumber_file?(p) || cucumber_folder?(p) }
          paths = paths.delete_if { |p| included_in_other_path?(p, paths) }
          clear_cucumber_files_list
          paths
        end

      private

        def cucumber_folder?(path)
          path.match(/^\/?features/) && !path.match(/\..+$/)
        end

        def cucumber_file?(path)
          cucumber_files.include?(path.split(':').first)
        end

        def cucumber_files
          @cucumber_files ||= Dir.glob('features/**/*.feature')
        end

        def clear_cucumber_files_list
          @cucumber_files = nil
        end

        def included_in_other_path?(path, paths)
          paths = paths.select { |p| p != path }
          paths.any? { |p| path.include?(p) && (path.gsub(p, '')).include?('/') }
        end

      end
    end
  end
end
