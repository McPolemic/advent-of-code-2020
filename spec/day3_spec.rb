require 'spec_helper'
require_relative '../day3/day3'
require 'stringio'

RSpec.describe Day3 do
  describe 'solve' do
    it 'counts tress on the way down' do
      map = StringIO.new <<~EOF
        ..##.......
        #...#...#..
        .#....#..#.
        ..#.#...#.#
        .#...##..#.
        ..#.##.....
        .#.#.#....#
        .#........#
        #.##...#...
        #...##....#
        .#..#...#.#
      EOF

      expect(Day3.solve(map)).to eq 7
    end
  end
end
