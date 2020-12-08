require 'set'

program = File.read("input.txt")
  .split("\n")
  .map do |line|
    operation, argument = line.split(" ")
    [operation, argument.to_i]
  end

def run_program(program)
  acc = 0
  current_line = 0
  visited_lines = Set.new

  # Returns when a loop is detected
  until current_line >= program.count
    return if visited_lines.include? current_line
    visited_lines << current_line

    operation, argument = program[current_line]
    case operation
    when "jmp"
      current_line += argument
      next
    when "acc"
      acc += argument
    end

    current_line += 1
  end

  acc
end
