require 'spec_helper'
require_relative '../day8/day8'
require 'stringio'

RSpec.describe VirtualMachine do
  describe '#run' do
    it 'runs until a loop is detected' do
      program = [
        "nop +0",
        "acc +1",
        "jmp +4",
        "acc +3",
        "jmp -3",
        "acc -99",
        "acc +1",
        "jmp -4",
        "acc +6",
      ]
      machine = VirtualMachine.new(program)
      
      expect { machine.run! }.to raise_error VirtualMachine::LoopDetected
      expect(machine.acc).to eq 5
    end
  end

  describe '#rewrite_operation_at_line' do
    it 'rewrites the operation, leaving the argument alone' do
      program = ["nop +0" ]
      machine = VirtualMachine.new(program)
      machine.rewrite_operation_at_line(0, "jmp")
      
      expect(machine.program).to match_array ["jmp +0"]
    end
  end

  describe 'dup' do
    it 'does not rewrite a source machine' do
      program = ["nop +0" ]
      machine = VirtualMachine.new(program)

      rewritten_machine = machine.dup
      rewritten_machine.rewrite_operation_at_line(0, "jmp")
      
      expect(rewritten_machine.program).to match_array ["jmp +0"]
      expect(machine.program).to match_array program
    end
  end
end
