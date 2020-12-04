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
        ecl: 'gry',
        pid: '860033327',
        eyr: '2020',
        hcl: '#fffffd',
        byr: '1937',
        iyr: '2017',
        cid: '147',
        hgt: '183cm',
      }

      passport = Passport.from_a(fields)

      expected_fields.each do |name, _|
        expect(passport[name]).to be
      end
    end
  end

  describe '#valid_height?' do
    it 'is valid if the height is between 150cm and 193cm' do
      height = '150cm'
      passport = Passport.new(nil, nil, nil, height)

      expect(passport).to be_valid_height
    end

    it 'cannot be too short (<150cm or <59in)' do
      height = '10in'
      passport = Passport.new(nil, nil, nil, height)

      expect(passport).not_to be_valid_height
    end

    it 'cannot be too tall (>193cm or >76in)' do
      height = '194cm'
      passport = Passport.new(nil, nil, nil, height)

      expect(passport).not_to be_valid_height
    end
  end

  describe '#valid_hair_color?' do
    it 'must be six valid hex characters' do
      hair_color = '#123abc'
      passport = Passport.new(nil, nil, nil, nil, hair_color)

      expect(passport).to be_valid_hair_color
    end

    it 'must only use 0-9,a-f' do
      hair_color = '#00000z'
      passport = Passport.new(nil, nil, nil, nil, hair_color)

      expect(passport).not_to be_valid_hair_color
    end

    it 'must have a leading "#"' do
      hair_color = ' 000000'
      passport = Passport.new(nil, nil, nil, nil, hair_color)

      expect(passport).not_to be_valid_hair_color
    end
  end

  describe '#valid_eye_color?' do
    it 'must be one of the listed valid eye colors' do
      eye_color = 'grn'
      passport = Passport.new(nil, nil, nil, nil, nil, eye_color)

      expect(passport).to be_valid_eye_color
    end

    it 'reject all substitues' do
      eye_color = 'zzz'
      passport = Passport.new(nil, nil, nil, nil, nil, eye_color)

      expect(passport).not_to be_valid_eye_color
    end
  end

  describe '#valid_passport_id?' do
    it 'must be a zero-padded nine digit number' do
      passport_id = '001234567'
      passport = Passport.new(nil, nil, nil, nil, nil, nil, passport_id)

      expect(passport).to be_valid_passport_id
    end

    it 'cannot be shorter than nine digits' do
      passport_id = '1234567'
      passport = Passport.new(nil, nil, nil, nil, nil, nil, passport_id)

      expect(passport).not_to be_valid_passport_id
    end

    it 'cannot be longer than nine digits' do
      passport_id = '1234567890123'
      passport = Passport.new(nil, nil, nil, nil, nil, nil, passport_id)

      expect(passport).not_to be_valid_passport_id
    end
  end

  describe '#valid?' do
    let(:fields) do
      [
        'byr:1990',
        'iyr:2012',
        'eyr:2020',
        'hgt:60in',
        'hcl:#abc123',
        'ecl:amb',
        'pid:123456789',
      ]
    end

    it 'is valid if all required fields are present' do
      passport = Passport.from_a(fields)

      expect(passport.valid?).to be true
    end

    it 'is invalid if one required field is missing (pid)' do
      passport = Passport.from_a(fields[0...-1])

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
      # The first four passports are invalid for various reasons
      # The second four are valid
      file = StringIO.new <<~EOF
        hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

        iyr:2019
        hcl:#602927 eyr:1967 hgt:170cm
        ecl:grn pid:012533040 byr:1946

        hcl:dab227 iyr:2012
        ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

        hgt:59cm ecl:zzz
        eyr:2038 hcl:74454a iyr:2023
        pid:3556412378 byr:2007

        pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
        hcl:#623a2f

        eyr:2029 ecl:blu cid:129 byr:1989
        iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

        hcl:#888785
        hgt:164cm byr:2001 iyr:2015 cid:88
        pid:545766238 ecl:hzl
        eyr:2022

        iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
      EOF

      expect(Day4.solve(file)).to eq 4
    end
  end
end
