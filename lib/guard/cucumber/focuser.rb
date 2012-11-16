module Guard
  class Cucumber

    # The Cucumber focuser focuses the paths to sections
    # tagged with '@focus'
    #
    module Focuser
      class << self

        def focus(paths, focus_tag)
          return false if paths.empty?

          updated_paths = []

          paths.each do |path|
            focussed_line_numbers = scan_path_for_focus_tag(path, focus_tag)

            unless focussed_line_numbers.empty?
              updated_paths << append_line_numbers_to_path(
                focussed_line_numbers, path
              )
            else
              updated_paths << path
            end
          end

          updated_paths
        end

        def scan_path_for_focus_tag(path, focus_tag)
          line_numbers = []

          File.open(path, 'r') do |f|
            while (line = f.gets)
              if line.include?(focus_tag)
                line_numbers << f.lineno
              end
            end
          end

          line_numbers
        end

        def append_line_numbers_to_path(line_numbers, path)
          line_numbers.each { |num| path += ":" + num.to_s }

          path
        end



      end
    end
  end
end
