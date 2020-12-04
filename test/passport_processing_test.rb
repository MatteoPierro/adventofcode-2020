# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/passport_processing'

class PassportProcessingTest < Minitest::Test
  def test_valid_passport
    valid_passport = 'ecl:gry pid:860033327 eyr:2020 hcl:#fffffd byr:1937 iyr:2017 cid:147 hgt:183cm'
    assert PassportProcessing.valid?(valid_passport)
  end

  def test_invalid_passport
    invalid_passport = 'pid:860033327 eyr:2020 hcl:#fffffd byr:1937 iyr:2017 cid:147 hgt:183cm'
    assert_equal PassportProcessing.valid?(invalid_passport), false
  end

  def test_still_valid_passport_with_missing_cid
    valid_passport = 'ecl:gry pid:860033327 eyr:2020 hcl:#fffffd byr:1937 iyr:2017 hgt:183cm'
    assert PassportProcessing.valid?(valid_passport)
  end

  def test_can_parse_passport_file
    passport_filepath = './test/passport_file.txt'
    passports = PassportProcessing.parse(passport_filepath)
    assert_equal 4, passports.count
  end

  def test_count_valid_passport
    passport_filepath = './test/passport_file.txt'
    assert_equal 2, PassportProcessing.count_valid_passports(passport_filepath)
  end

  def test_first_puzzle_solution
    assert_equal 239, PassportProcessing.count_valid_passports
  end
end
