require 'spec_helper'
require_relative '../day2/day2'
require 'stringio'

RSpec.describe Day2 do
  describe '.password_valid?' do
    # This example contain 1-3 "a"s (one "a", to be precise)
    xit 'says that a password that follows the rules is valid' do
      input = "1-3 a: abcde"
      expect(Day2.password_valid?(input)).to be true
    end

    it 'says that a password that does not follow the rules is invalid' do
      # This example does not contain 1-3 "b"s
      input = "1-3 b: cdefg"
      expect(Day2.password_valid?(input)).to be false

      # This example has multiple digits in the min/max and not enough "k"s
      input = "19-20 k: kkkkkkkkkkkkkkdkkkkx"
      expect(Day2.password_valid?(input)).to be false
    end
  end

  xdescribe 'solve' do
    it "accepts multiple lines and counts how many are valid" do
      input = <<~EOF
        1-3 a: abcde
        1-3 a: abcde
        1-3 a: abcde
        1-3 b: cdefg
      EOF
      file = StringIO.new(input)

      expect(Day2.solve(file)).to eq 3
    end
  end
end

