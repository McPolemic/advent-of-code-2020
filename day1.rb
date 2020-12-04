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

  def self.find_2020_triple(input)
    (0 ... input.length).each do |i|
      (i+1 ... input.length).each do |j|
        (j+1 ... input.length).each do |k|
          first, second, third = input[i], input[j], input[k]
          return [first, second, third] if first + second + third == 2020
        end
      end
    end
  end

  def self.solve_triple(input)
    input = input.map(&:to_i)
    first, second, third = find_2020_triple(input)

    first * second * third
  end
end

puts "Product of two entries: #{Day1.solve_pair(ARGV)}" if __FILE__ == $0
puts "Product of three entries: #{Day1.solve_triple(ARGV)}" if __FILE__ == $0
