class PasswordParser
  attr_reader :min, :max, :letter, :password

  def initialize(min, max, letter, password)
    @min = min.to_i
    @max = max.to_i
    @letter = letter
    @password = password
  end

  def self.parse_from_line(line)
    rule, password = line.split(": ")
    # Pull apart the string "1-3 a"
    # 1 - minimum number of occurrences for the letter
    # 3 - maximum number of occurrences for the letter
    # a - the letter
    _, min, max, letter = rule.match(/(\d+)\-(\d+) (\w)/).to_a
    self.new(min, max, letter, password)
  end

  def valid_password?
    count = password.chars.count(letter)
    return true if count >= min && count <= max

    false
  end
end

class Day2
  def self.password_valid?(line)
    PasswordParser.parse_from_line(line).valid_password?
  end

  def self.solve(input_file)
    lines = input_file.read.split("\n").map(&:strip)
    lines.map{ |line| password_valid?(line) }.count(true)
  end
end

puts Day2.solve(File.open(ARGV.first, 'r')) if __FILE__ == $0
