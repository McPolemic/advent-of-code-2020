require 'set'

# Ideas for improvement
# * There's no reason to keep the instructions as strings. Pull them out into
#   classes for easier reading/manipulation.
class VirtualMachine
  attr_reader :program, :acc, :current_line, :log

  def initialize(program, log: false)
    @program = program.dup
    @acc = 0
    @current_line = 0
    @executed_lines = Set.new
    @log = log
  end

  # Ensure we're duplicating the program so we don't modify the original
  def dup
    self.class.new(program.dup, log: log)
  end

  class LoopDetected < StandardError; end

  def looping?
    @executed_lines.include? current_line 
  end

  def finished?
    current_line >= program.count
  end

  def run!
    until finished?
      raise LoopDetected if looping?
      @executed_lines << current_line

      instruction = program[current_line]
      operation, argument = instruction.split(" ")
      argument = argument.to_i

      case operation
      when "acc"
        puts "#{current_line}: Accumulating by #{argument}" if log
        @acc += argument
      when "jmp"
        next_line = current_line + argument
        puts "#{current_line}: Jumping to line #{next_line}" if log
        @current_line = next_line
        next
      when "nop"
        puts "#{current_line}: No-op" if log
      end

      @current_line += 1
    end
  end

  def rewrite_operation_at_line(line_number, new_operation)
    instruction = program[line_number]
    _, argument = instruction.split(" ")

    rewritten_line = "#{new_operation} #{argument}"
    program[line_number] = rewritten_line
  end
end

# There's definitely a more elegant way to handle this, but it's late
def rewrite_jmps(machine)
  jmp_lines = machine.program
    .each_with_index
    .select{|line,index| line =~ /^jmp/}
    .map(&:last)

  jmp_lines.each do |line_number|
    rewritten_machine = machine.dup
    rewritten_machine.rewrite_operation_at_line(line_number, "nop")

    begin
      rewritten_machine.run!
      puts "Replacing #{line_number} with a nop fixes the program."
      puts "Accumulator ends with #{rewritten_machine.acc}"
    rescue VirtualMachine::LoopDetected
      next
    end
  end
end

def rewrite_nops(machine)
  nop_lines = machine.program
    .each_with_index
    .select{|line,index| line =~ /^nop/}
    .map(&:last)

  nop_lines.each do |line_number|
    rewritten_machine = machine.dup
    rewritten_machine.rewrite_operation_at_line(line_number, "jmp")

    begin
      rewritten_machine.run!
      puts "Replacing #{line_number} with a jmp fixes the program."
      puts "Accumulator ends with #{rewritten_machine.acc}"
    rescue VirtualMachine::LoopDetected
      next
    end
  end
end

class Day8
  def self.solve(input_file)
    lines = input_file.read.each_line.map(&:strip)
    machine = VirtualMachine.new(lines)

    rewrite_jmps(machine)
    rewrite_nops(machine)

    false
  end
end

puts Day8.solve(File.open(ARGV.first, 'r')) if __FILE__ == $0
