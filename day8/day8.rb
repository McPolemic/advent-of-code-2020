require 'set'

class VirtualMachine
  attr_reader :program, :acc, :current_line, :log

  def initialize(program, log: false)
    @program = program
    @acc = 0
    @current_line = 0
    @executed_lines = Set.new
    @log = log
  end

  class LoopDetected < StandardError; end

  def looping?
    @executed_lines.include? current_line 
  end

  def finished?
    current_line > program.count
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
end

class Day8
  def self.solve(input_file)
    lines = input_file.read.each_line.map(&:strip)
    machine = VirtualMachine.new(lines)
    machine.run!
  rescue VirtualMachine::LoopDetected
    machine.acc
  end
end

puts Day8.solve(File.open(ARGV.first, 'r')) if __FILE__ == $0
