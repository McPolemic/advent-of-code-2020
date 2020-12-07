require 'spec_helper'
require_relative '../day6/day6'

RSpec.describe CustomsForm do
  describe '.from_group_answers' do
    it 'does not return an answer unless all people said "Yes"' do
      input = ['ab', 'cd']
      form = CustomsForm.from_group_answers(input)

      expect(form.answers).to eq []
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

      #       b 1 (removing duplicate "b" and not everyone in the group answered "a" or "c")
      # a,b,c,d 4
      # 5 total
      expected_sum = 5

      expect(Day6.solve(input)).to eq expected_sum
    end
  end
end
