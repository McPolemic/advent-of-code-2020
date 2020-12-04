require 'spec_helper'
require_relative '../day4/day4'
require 'stringio'

RSpec.describe Passport do
  describe '.from_a' do
    it 'makes a Passport out of an array of fields' do
      fields = [
        'ecl:gry',
        'pid:860033327',
        'eyr:2020',
        'hcl:#fffffd',
        'byr:1937',
        'iyr:2017',
        'cid:147',
        'hgt:183cm',
      ]
      expected_fields = {
        'ecl' => 'gry',
        'pid' => '860033327',
        'eyr' => '2020',
        'hcl' => '#fffffd',
        'byr' => '1937',
        'iyr' => '2017',
        'cid' => '147',
        'hgt' => '183cm',
      }

      passport = Passport.from_a(fields)

      expect(passport.fields).to eq expected_fields
    end
  end

  describe '#valid?' do
    let(:fields) do
      {
        'byr' => :ignored,
        'iyr' => :ignored,
        'eyr' => :ignored,
        'hgt' => :ignored,
        'hcl' => :ignored,
        'ecl' => :ignored,
        'pid' => :ignored,
      }
    end

    it 'is valid if all required fields are present' do
      passport = Passport.new(fields)

      expect(passport.valid?).to be true
    end

    it 'is invalid if one required field is missing (pid)' do
      input = fields.reject{ |k,_| k == "pid" }
      passport = Passport.new(input)

      expect(passport.valid?).to be false
    end
  end
end

RSpec.describe PassportParser do
  describe '.parse_passports' do
    it 'parses passports that have fields on the same or different lines' do
       input = <<~EOF
        ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
        byr:1937 iyr:2017 cid:147 hgt:183cm

        iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
        hcl:#cfa07d byr:1929

        hcl:#ae17e1 iyr:2013
        eyr:2024
        ecl:brn pid:760753108 byr:1931
        hgt:179cm

        hcl:#cfa07d eyr:2025 pid:166559648
        iyr:2011 ecl:brn hgt:59in
      EOF
      expected_count = 4

      output = PassportParser.parse_passports(input)

      expect(output.count).to eq expected_count
    end
  end

  describe '.normalize_input' do
    it 'does not modify when all fields are on their own lines' do
      input = "ecl:gry\npid:860033327\neyr:2020\nhcl:#fffffd"

      output = PassportParser.normalize_input(input)

      expect(output).to eq input
    end

    it 'moves fields that are on the same line onto different lines' do
      input = "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd"
      output = "ecl:gry\npid:860033327\neyr:2020\nhcl:#fffffd"

      output = PassportParser.normalize_input(input)

      expect(output).to eq output
    end
  end
end

RSpec.describe Day4 do
  describe 'solve' do
    it 'parses and counts valid passports' do
      # Contains two valid passports, the first and third
      # The second is missing the required field 'hgt'
      # The fourth is missing the required field 'byr'
      file = StringIO.new <<~EOF
        ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
        byr:1937 iyr:2017 cid:147 hgt:183cm

        iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
        hcl:#cfa07d byr:1929

        hcl:#ae17e1 iyr:2013
        eyr:2024
        ecl:brn pid:760753108 byr:1931
        hgt:179cm

        hcl:#cfa07d eyr:2025 pid:166559648
        iyr:2011 ecl:brn hgt:59in
      EOF

      expect(Day4.solve(file)).to eq 2
    end
  end
end
