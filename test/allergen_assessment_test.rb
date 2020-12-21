# frozen_string_literal: true

require 'minitest/autorun'
require 'set'

class AllergenAssessmentTest < Minitest::Test
  def test_first_puzzle
    skip
    allergen_assessment = AllergenAssessment.from_file('./lib/allergen_assessment.txt')

    assert_equal(2302, allergen_assessment.ok_ingredients.count)
  end

  def test_second_puzzle
    skip
    allergen_assessment = AllergenAssessment.from_file('./lib/allergen_assessment.txt')

    assert_equal('smfz,vhkj,qzlmr,tvdvzd,lcb,lrqqqsg,dfzqlk,shp', allergen_assessment.ingredients_sorted_by_allergens)
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
      foods.flatten.reject { |ingredient| suspect_ingredients.include?(ingredient) }.to_a
    end

    def suspect_ingredients
      suspect_ingredients = []
      foods_by_allergens.each do |_, foods|
        suspect_ingredients << foods.reduce(&:&)
      end
      suspect_ingredients.flatten.to_set
    end

    def suspect_ingredients_by_allergens
      suspect_ingredients = {}
      foods_by_allergens.each do |allergen, foods|
        suspect_ingredients[allergen] ||= []
        suspect_ingredients[allergen] += foods.reduce(&:&).to_a
      end
      suspect_ingredients
    end

    def find_allergen_ingredient(allergen_ingredient = suspect_ingredients_by_allergens)
      return allergen_ingredient if allergen_ingredient.all? { |_, ingredients| ingredients.count == 1 }

      solved_ingredients = allergen_ingredient.select { |_, ingredients| ingredients.count == 1 }
                                              .map { |_, ingredients| ingredients.first }

      allergen_ingredient.each do |allergen, ingredients|
        next if ingredients.count == 1

        allergen_ingredient[allergen] = ingredients - solved_ingredients
      end

      find_allergen_ingredient(allergen_ingredient)
    end

    def ingredients_sorted_by_allergens
      allergen_ingredient = find_allergen_ingredient
      allergen_ingredient.keys.sort.map { |allergen| allergen_ingredient[allergen].first }.join(',')
    end
  end
end
