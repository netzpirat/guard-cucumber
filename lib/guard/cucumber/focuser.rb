module Guard
  class Cucumber

    # The Cucumber focuser updates cucumber feature paths to
    # focus on sections tagged with a provided focus_tag.
    #
    # For example, if the `foo.feature` file has the provided focus tag
    # `@bar` on line 8, then the path will be updated using the cucumber
    # syntax for focusing on a section:
    #
    # foo.feature:8
    #
    # If '@bar' is found on lines 8 and 16, the path is updated as follows:
    #
    # foo.feature:8:16
    #
    # The path is not updated if it does not contain the focus tag.
    #
    #
    module Focuser
      class << self

        # Focus the supplied paths using the provided focus tag.
        #
        # @param [Array<String>] paths the locations of the feature files
        # @param [String] focus_tag the focus tag to look for in each path
        # @return [Array<String>] the updated paths
        #
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

        # Checks to see if the file at path contains the focus tag
        #
        # @param [String] path the file path to search
        # @param [String] focus_tag the focus tag to look for in each path
        # @return [Array<Integer>] the line numbers that include the focus tag in path
        #
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

        # Appends the line numbers to the path
        #
        # @param [Array<Integer>] line_numbers the line numbers to append to the path
        # @param [String] path the path that will receive the appended line numbers
        # @return [String] the string containing the path appended with the line number
        #
        def append_line_numbers_to_path(line_numbers, path)
          line_numbers.each { |num| path += ":" + num.to_s }

          path
        end

      end
    end
  end
end
