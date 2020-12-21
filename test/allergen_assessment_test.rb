# frozen_string_literal: true

require 'minitest/autorun'
require 'set'

class AllergenAssessmentTest < Minitest::Test
  def test_first_puzzle
    allergen_assessment = AllergenAssessment.from_file('./lib/allergen_assessment.txt')

    assert_equal(2302, allergen_assessment.ok_ingredients.count)
  end

  class AllergenAssessment
    attr_reader :foods, :foods_by_allergens

    class << self
      def from_file(file_path)
        foods = []
        foods_by_allergens = {}
        File.readlines(file_path).each { |line| parse_line(line, foods, foods_by_allergens) }
        new(foods, foods_by_allergens)
      end

      def parse_line(line, foods, foods_by_allergens)
        match = line.match(/^(?<food>.+) \(contains (?<allergens>.+)\)$/)
        food = match[:food].split.to_a
        allergens = match[:allergens].split(', ')
        foods << food
        allergens.each do |allergen|
          foods_by_allergens[allergen] ||= []
          foods_by_allergens[allergen] << food
        end
      end
    end

    def initialize(foods, foods_by_allergens)
      @foods = foods
      @foods_by_allergens = foods_by_allergens
    end

    def ok_ingredients
      suspect_ingredients = suspect_ingredients(foods_by_allergens)
      foods.flatten.reject { |ingredient| suspect_ingredients.include?(ingredient) }.to_a
    end

    def suspect_ingredients(foods_by_allergens)
      suspect_ingredients = []
      foods_by_allergens.each do |_, foods|
        suspect_ingredients << foods.reduce(&:&)
      end
      suspect_ingredients.flatten.to_set
    end
  end
end
