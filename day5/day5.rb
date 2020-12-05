class SeatRange
  attr_reader :min, :max

  def initialize(min, max)
    @min = min
    @max = max
  end

  def size
    max - min
  end

  def first_half
    new_max = min + (size / 2)

    self.class.new(min, new_max)
  end

  def last_half
    new_min = min + (size / 2) + 1

    self.class.new(new_min, max)
  end
end

BoardingPass = Struct.new(:directions) do
  ROWS = 128
  COLUMNS = 8

  def row
    seats = SeatRange.new(0, ROWS-1)
    row_directions = directions[0..6].chars
    until row_directions.empty?
      case row_directions.shift
      when 'F'
        seats = seats.first_half
      when 'B'
        seats = seats.last_half
      end
    end

    seats.min
  end

  def column
    seats = SeatRange.new(0, COLUMNS-1)
    column_directions = directions[7..9].chars
    until column_directions.empty?
      case column_directions.shift
      when 'L'
        seats = seats.first_half
      when 'R'
        seats = seats.last_half
      end
    end

    seats.min
  end

  def seat_id
    row * 8 + column
  end
end

class Day5
  def self.solve(input_file)
    lines = input_file
      .read
      .each_line
      .map(&:strip)
      .map{ |line| BoardingPass.new(line).seat_id }
      .max
  end
end

puts Day5.solve(File.open(ARGV.first, 'r')) if __FILE__ == $0
