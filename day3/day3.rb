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
  def self.trees_on_slope(map, x_offset, y_offset)
    x = y = trees = 0
    while true
      x += x_offset
      y += y_offset
      trees += 1 if map.tree?(x, y)
      return trees if map.done?(y)
    end
  end

  def self.solve(input_file)
    lines = input_file.read.each_line.map(&:strip)
    map = Map.new(lines)

    trees_on_slope(map, 1, 1) *
      trees_on_slope(map, 3, 1) *
      trees_on_slope(map, 5, 1) *
      trees_on_slope(map, 7, 1) *
      trees_on_slope(map, 1, 2)
  end
end

puts Day3.solve(File.open(ARGV.first, 'r')) if __FILE__ == $0
