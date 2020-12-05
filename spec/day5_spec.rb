require 'spec_helper'
require_relative '../day5/day5'
require 'stringio'

RSpec.describe SeatRange do
  let(:seats) { SeatRange.new(0, 127) }

  it 'determines the first half of seats 0-127 is 0..63' do
    new_seats = seats.first_half

    expect(new_seats.min).to eq 0
    expect(new_seats.max).to eq 63
  end

  it 'determines the last half of seats 0-127 is 64..127' do
    new_seats = seats.last_half

    expect(new_seats.min).to eq 64
    expect(new_seats.max).to eq 127
  end
end

RSpec.describe BoardingPass do
  describe 'row' do
    it 'navigates to a correct row' do
      # Pulled from example
      pass = BoardingPass.new('FBFBBFFRLR')

      expect(pass.row).to eq 44
    end
  end

  describe 'column' do
    it 'navigates to a correct column' do
      # Pulled from example
      pass = BoardingPass.new('FBFBBFFRLR')

      expect(pass.column).to eq 5
    end
  end

  describe 'seat_id' do
    it 'calculates the correct seat ID' do
      # Pulled from example
      pass = BoardingPass.new('FBFBBFFRLR')

      expect(pass.seat_id).to eq 357
    end
  end
end

RSpec.describe Day5 do
  describe 'solve' do
    it 'finds the highest seat ID' do
      sample_problems = StringIO.new <<~EOF
        BFFFBBFRRR
        FFFBBBFRRR
        BBFFBBFRLL
      EOF

      expect(Day5.solve(sample_problems)).to eq 820
    end
  end
end
