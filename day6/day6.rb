require 'set'

class CustomsForm
  # `answers` is an array of letters indicating which questions the group said "Yes" to 
  attr_reader :answers

  def initialize(answers)
    @answers = answers
  end

  def self.from_group_answers(group)
    answers = group
      .flat_map{|line| line.chars}
      .group_by{|answer| answer}
      .select{|answer, answers| answer if answers.count == group.count}
      .keys

    self.new(answers)
  end
end

class Day6
  # Read in the input, split into separate lines, and make a group every time
  # there's a blank line. After all that, pass a given group into
  # `CustomsForm.from_group_answers` to generate a list of forms and then sum
  # up the answers.
  def self.solve(input_file)
    forms = input_file
      .read
      .each_line
      .map(&:strip)
      .chunk{ |line| line == ""}
      .select{ |group| group.first == false }
      .map{ |group| group.last }
      .flat_map{ |group| CustomsForm.from_group_answers(group).answers }
      .group_by{ |answer| answer }
      .map{ |k,v| v.count }
      .sum
  end
end

puts Day6.solve(File.open(ARGV.first, 'r')) if __FILE__ == $0
