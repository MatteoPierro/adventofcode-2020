# frozen_string_literal: true

module FirstDay
  class << self
    def file_lines(path)
      File.open(path).each_line.map(&:chop)
    end

    def combinations(array:, size:)
      array.combination(size)
    end
  end
end
