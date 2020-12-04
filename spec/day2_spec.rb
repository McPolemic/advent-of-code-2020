require 'spec_helper'
require_relative '../day2/day2'
require 'stringio'

RSpec.describe LegacyPasswordParser do
  describe '.valid_password?' do
    # This example contain 1-3 "a"s (one "a", to be precise)
    it 'says that a password that follows the rules is valid' do
      input = "1-3 a: abcde"
      result = LegacyPasswordParser.parse_from_line(input).valid_password?

      expect(result).to be true
    end

    it 'says that a password that does not follow the rules is invalid' do
      # This example does not contain 1-3 "b"s
      input = "1-3 b: cdefg"
      result = LegacyPasswordParser.parse_from_line(input).valid_password?
      expect(result).to be false

      # This example has multiple digits in the min/max and not enough "k"s
      input = "19-20 k: kkkkkkkkkkkkkkdkkkkx"
      result = LegacyPasswordParser.parse_from_line(input).valid_password?
      expect(result).to be false
    end
  end
end

RSpec.describe PasswordParser do
  describe '.valid_password?' do
    # This example contains one "a" at index 1
    it 'says that a password that follows the rules is valid' do
      input = "1-3 a: abcde"
      result = PasswordParser.parse_from_line(input).valid_password?

      expect(result).to be true
    end

    it 'says that a password that does not follow the rules is invalid' do
      # This example does not contain a "b" for the first or third character
      input = "1-3 b: cbebb"
      result = PasswordParser.parse_from_line(input).valid_password?
      expect(result).to be false
    end
  end
end

RSpec.describe Day2 do
  describe 'solve' do
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

