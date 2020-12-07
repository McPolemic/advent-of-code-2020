BagQuantity = Struct.new(:amount, :description)

class BagRules
  attr_reader :rules

  # `rules` is a hash with a key of a bag's description and a value of the bags it can hold
  def initialize(rules)
    @rules = rules
  end

  def self.from_rules(lines)
    rules = Hash.new{|h,k| h[k] = []}
    lines.each do |sentence|
      next if sentence.include? "contain no other bags."

      # a rule consists of a source description (what you're holding) and the
      # description of bags it can contain. We split it into
      # `source => [targets]`.
      source, *targets = sentence.scan(/((?:\d+ )*\w+ \w+) bags?/).flatten

      targets.each do |target|
        amount, description = target.scan(/(\d+) (\w+ \w+)/).flatten
        rules[source] << BagQuantity.new(amount.to_i, description)
      end
    end

    self.new(rules)
  end

  def contains_how_many_of_type(source, target)
    amounts = rules[source].map do |bag|
      [bag.description, bag.amount]
    end.to_h

    # Return the amount if we've found it
    return amounts[target] if amounts[target]
    
    # Otherwise, loop through all the destinations we know and check those
    amounts.map do |description, amount|
      amount * contains_how_many_of_type(description, target)
    end.sum
  end

  def what_can_hold_type(target)
    # Find what types can hold target (amount > 0)
    rules
      .keys
      .select{ |description| contains_how_many_of_type(description, target) > 0 }
  end
end

class Day7
  def self.solve(input_file)
    lines = input_file.read.each_line.map(&:strip)
    rules = BagRules.from_rules(lines)

    rules.what_can_hold_type('shiny gold').count
  end
end

puts Day7.solve(File.open(ARGV.first, 'r')) if __FILE__ == $0
