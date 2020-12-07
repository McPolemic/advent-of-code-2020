require 'spec_helper'
require_relative '../day6/day6'

RSpec.describe CustomsForm do
  describe '.from_group_answers' do
    it 'consolidates multiple answers' do
      input = ['ab', 'cd']
      form = CustomsForm.from_group_answers(input)

      expect(form.answers).to eq ['a', 'b', 'c', 'd']
    end

    it 'removes duplicate answers' do
      input = ['ab', 'ab']
      form = CustomsForm.from_group_answers(input)

      expect(form.answers).to eq ['a', 'b']
    end
  end
end

RSpec.describe Day6 do
  describe 'solve' do
    it 'sums up unique answers' do
      input = StringIO.new <<~EOF
        ab
        bc

        abcd
      EOF

      # a,b,c (removing duplicate "b") and a,b,c,d == 7
      expected_sum = 7

      expect(Day6.solve(input)).to eq expected_sum
    end
  end
end
