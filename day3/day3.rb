Map = Struct.new(:lines) do
  def tree?(x, y)
    max_width = lines.first.size

    lines[y][x % max_width] == '#'
  end

  def done?(y)
    y >= lines.count - 1
  end
end

class Day3
  def self.solve(input_file)
    lines = input_file.read.each_line.map(&:strip)
    map = Map.new(lines)

    x = y = trees = 0
    while true
      x += 3
      y += 1
      trees += 1 if map.tree?(x, y)
      return trees if map.done?(y)
    end
  end
end

puts Day3.solve(File.open(ARGV.first, 'r')) if __FILE__ == $0
