require 'set'

Passport = Struct.new(:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid, :cid) do
  REQUIRED_FIELDS = %i{byr iyr eyr hgt hcl ecl pid}
  VALID_EYE_COLORS = %w{amb blu brn gry grn hzl oth}.to_set
  # Convert an array of ["byr:gry", "iyr:2017"] into a Passport with
  # fields={"byr": "gry", "iyr": "2017"}
  def self.from_a(array_of_fields)
    fields = Hash[array_of_fields.map{ |e| e.split(":") }]

    self.new(
      fields['byr'].to_i,
      fields['iyr'].to_i,
      fields['eyr'].to_i,
      fields['hgt'],
      fields['hcl'],
      fields['ecl'],
      fields['pid'],
      fields['cid'],
    )
  end

  def valid_height?
    _, amount, units = hgt.match(/(\d+)(.+)/).to_a
    amount = amount.to_i

    case units
    when "cm"
      amount.between? 150, 193
    when "in"
      amount.between? 59, 76
    else
      return false
    end
  end

  def valid_hair_color?
    hcl.match(/#[0-9a-f]{6}/)
  end

  def valid_eye_color?
    VALID_EYE_COLORS.include? ecl
  end

  def valid_passport_id?
    pid.match(/^\d{9}$/)
  end

  def valid?
    return false if REQUIRED_FIELDS.any? do |field|
      self[field].nil?
    end

    return false unless valid_height? &&
      valid_hair_color? &&
      valid_eye_color? &&
      valid_passport_id? &&
      byr.between?(1920, 2002) &&
      iyr.between?(2010, 2020) &&
      eyr.between?(2020, 2030)

    true
  end
end

class PassportParser
  # Ensure each field is on its own line by converting spaces to newlines
  def self.normalize_input(input)
    input.gsub(" ", "\n")
  end

  def self.parse_passports(input)
    input = normalize_input(input)

    # Split on newlines (so we have an array of individual fields with empty
    # fields separating passports). Then chunk the passports on empty fields
    input
      .each_line
      .map(&:strip)
      .chunk { |el| el == '' }
      .select { |el| el.first == false }
      .map { |el| el.last }
      .map { |fields| Passport.from_a(fields) }
  end
end

class Day4
  def self.solve(input_file)
    input = input_file.read

    PassportParser.parse_passports(input).select(&:valid?).count
  end
end

puts Day4.solve(File.open(ARGV.first, 'r')) if __FILE__ == $0
