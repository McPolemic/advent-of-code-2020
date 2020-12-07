require 'spec_helper'
require_relative '../day7/day7'

RSpec.describe BagRules do
  describe '.from_rules' do
    it 'imports a single rule' do
      input = ["light red bags contain 1 bright white bag, 2 muted yellow bags."]
      expected = {
        'light red' => [
          BagQuantity.new(1, 'bright white'),
          BagQuantity.new(2, 'muted yellow'),
        ]
      }

      bag_rules = BagRules.from_rules(input)

      expect(bag_rules.rules).to eq expected
    end

    it 'imports rules two levels deep' do
      input = [
        "light red bags contain 2 bright white bags.",
        "bright white bags contain 1 muted yellow bag.",
      ]
      expected = {
        'light red' => [BagQuantity.new(2, 'bright white')],
        'bright white' => [BagQuantity.new(1, 'muted yellow')]
      }

      bag_rules = BagRules.from_rules(input)

      expect(bag_rules.rules).to eq expected
    end

    it 'ignores dead-end rules' do
      input = ["faded blue bags contain no other bags."]
      expected = {}

      bag_rules = BagRules.from_rules(input)

      expect(bag_rules.rules).to eq expected
    end
  end

  describe '.contains_how_many_of_type' do
    it 'can track one relationship down' do
      input = ["light red bags contain 2 bright white bags."]
      rules = BagRules.from_rules(input)

      bright_white_bag_count = rules.contains_how_many_of_type('light red', 'bright white')

      expect(bright_white_bag_count).to eq 2
    end

    it 'can track two relationships down and track multiplication' do
      input = [
        "light red bags contain 2 bright white bag.",
        "bright white bags contain 2 muted yellow bags.",
      ]
      rules = BagRules.from_rules(input)

      bright_white_bag_count = rules.contains_how_many_of_type('light red', 'muted yellow')

      expect(bright_white_bag_count).to eq 4
    end

    it 'returns 0 when it does not find a source or destination' do
      input = [
        "light red bags contain 2 bright white bag.",
        "bright white bags contain 2 muted yellow bags.",
      ]
      rules = BagRules.from_rules(input)

      source_count = rules.contains_how_many_of_type('dusty black', 'muted yellow')
      destination_count = rules.contains_how_many_of_type('light red', 'dusty black')

      expect(source_count).to eq 0
      expect(destination_count).to eq 0
    end
  end

  describe 'what_can_hold_type' do
    it 'lists which bags hold a target type' do
      input = [
        "light red bags contain 2 bright white bag.",
        "bright white bags contain 2 muted yellow bags.",
        "faded orange bags contain 1 dusty black bag.",
      ]
      rules = BagRules.from_rules(input)

      containing_bags = rules.what_can_hold_type('muted yellow')

      expect(containing_bags).to match_array ['light red', 'bright white']
    end
  end
end

RSpec.describe Day7 do
  describe 'solve' do
    it 'counts how many bags a shiny gold bag holds' do
      input = StringIO.new <<~EOF
        shiny gold bags contain 2 dark red bags.
        dark red bags contain 2 dark orange bags.
        dark orange bags contain 2 dark yellow bags.
        dark yellow bags contain 2 dark green bags.
        dark green bags contain 2 dark blue bags.
        dark blue bags contain 2 dark violet bags.
        dark violet bags contain no other bags.
      EOF

      expect(Day7.solve(input)).to eq 126
    end
  end
end
