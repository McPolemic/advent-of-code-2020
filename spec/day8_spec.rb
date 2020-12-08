require 'spec_helper'
require_relative '../day8/day8'

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
end

RSpec.describe Day8 do
  describe 'solve' do
  end
end
