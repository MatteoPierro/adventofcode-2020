# frozen_string_literal: true

class File
  def self.readlines(path)
    File.open(path).each_line.map(&:chop)
  end

  def self.read_blocks(path)
    File.readlines(path)
        .chunk(&:empty?)
        .map { |_, v| v }
        .reject { |l| l.empty? || l.first.empty? }
  end
end
