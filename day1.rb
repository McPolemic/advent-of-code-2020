class Day1
  def self.find_2020_pair(input)
    while input
      first = input.shift
      second = input.find { |n| first + n == 2020 }

      return [first, second] if second
    end
  end

  def self.solve_pair(input)
    input = input.map(&:to_i)
    first, second = find_2020_pair(input)

    first * second
  end
end

puts Day1.solve_pair(ARGV) if __FILE__ == $0
