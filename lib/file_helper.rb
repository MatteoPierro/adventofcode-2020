# frozen_string_literal: true

class File
  def self.readlines(path)
    File.open(path).each_line.map(&:chop)
  end
end
