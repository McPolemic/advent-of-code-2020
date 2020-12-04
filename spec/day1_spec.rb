require 'spec_helper'
require_relative '../day1/day1'

RSpec.describe Day1 do
  let (:input) {
    [
      1721,
      979,
      366,
      299,
      675,
      1456,
    ]
  }

  describe 'find_2020_pair' do
    it 'finds the two numbers that add up to 2020' do
      expect(Day1.find_2020_pair(input)).to eq [1721, 299]
    end
  end

  describe 'find_2020_triple' do
    it 'finds the three numbers that add up to 2020' do
      expect(Day1.find_2020_triple(input)).to eq [979, 366, 675]
    end
  end

  describe 'solve_pair' do
    it 'finds two entries that sum to 2020 and multiplies them' do
      expect(Day1.solve_pair(input)).to eq 514579
    end
  end
end
