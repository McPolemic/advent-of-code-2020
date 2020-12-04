Passport = Struct.new(:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid, :cid) do
  REQUIRED_FIELDS = %i{byr iyr eyr hgt hcl ecl pid}
  # Convert an array of ["byr:gry", "iyr:2017"] into a Passport with
  # fields={"byr": "gry", "iyr": "2017"}
  def self.from_a(array_of_fields)
    fields = Hash[array_of_fields.map{ |e| e.split(":") }]

    self.new(
      fields['byr'],
      fields['iyr'],
      fields['eyr'],
      fields['hgt'],
      fields['hcl'],
      fields['ecl'],
      fields['pid'],
      fields['cid'],
    )
  end

  def valid?
    REQUIRED_FIELDS.none?{ |required_field| self[required_field].nil? }
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
