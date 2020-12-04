# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/passport_processing'

class PassportProcessingTest < Minitest::Test
  def test_valid_passport
    valid_passport = 'ecl:gry pid:860033327 eyr:2020 hcl:#fffffd byr:1937 iyr:2017 cid:147 hgt:183cm'
    assert PassportProcessing::SIMPLE_VALIDATOR.call(valid_passport)
  end

  def test_invalid_passport
    invalid_passport = 'pid:860033327 eyr:2020 hcl:#fffffd byr:1937 iyr:2017 cid:147 hgt:183cm'
    assert_equal PassportProcessing::SIMPLE_VALIDATOR.call(invalid_passport), false
  end

  def test_still_valid_passport_with_missing_cid
    valid_passport = 'ecl:gry pid:860033327 eyr:2020 hcl:#fffffd byr:1937 iyr:2017 hgt:183cm'
    assert PassportProcessing::SIMPLE_VALIDATOR.call(valid_passport)
  end

  def test_can_parse_passport_file
    passport_filepath = './test/passport_file.txt'
    passports = PassportProcessing.parse(passport_filepath)
    assert_equal 4, passports.count
  end

  def test_count_valid_passport
    passport_filepath = './test/passport_file.txt'
    assert_equal 2, PassportProcessing.count_valid_passports(passport_filepath: passport_filepath)
  end

  def test_first_puzzle_solution
    assert_equal 239, PassportProcessing.count_valid_passports
  end

  def test_passport_with_invalid_birth_year
    invalid_passport = 'byr:1919 ecl:gry pid:860033327 eyr:2020 hcl:#fffffd iyr:2017 cid:147 hgt:183cm'
    assert_equal false, PassportProcessing::COMPLETE_VALIDATOR.call(invalid_passport)
  end

  def test_passport_with_invalid_issue_year
    invalid_passport = 'iyr:2099 byr:1921 ecl:gry pid:860033327 eyr:2020 hcl:#fffffd cid:147 hgt:183cm'
    assert_equal false, PassportProcessing::COMPLETE_VALIDATOR.call(invalid_passport)
  end

  def test_passport_with_invalid_expiration_year
    invalid_passport = 'eyr:2010 iyr:2019 byr:1921 ecl:gry pid:860033327 hcl:#fffffd cid:147 hgt:183cm'
    assert_equal false, PassportProcessing::COMPLETE_VALIDATOR.call(invalid_passport)
  end

  def test_passport_with_invalid_height_in_cm
    invalid_passport = 'hgt:200cm eyr:2020 iyr:2019 byr:1921 ecl:gry pid:860033327 hcl:#fffffd cid:147'
    assert_equal false, PassportProcessing::COMPLETE_VALIDATOR.call(invalid_passport)
  end

  def test_passport_with_invalid_height_in_in
    invalid_passport = 'hgt:50in eyr:2020 iyr:2019 byr:1921 ecl:gry pid:860033327 hcl:#fffffd cid:147'
    assert_equal false, PassportProcessing::COMPLETE_VALIDATOR.call(invalid_passport)
  end

  def test_passport_with_invalid_hair_color
    invalid_passport = 'hcl:#123abz hgt:61in eyr:2020 iyr:2019 byr:1921 ecl:gry pid:860033327 cid:147'
    assert_equal false, PassportProcessing::COMPLETE_VALIDATOR.call(invalid_passport)
  end

  def test_passport_with_invalid_eye_color
    invalid_passport = 'ecl:caz hcl:#123abc hgt:61in eyr:2020 iyr:2019 byr:1921 pid:860033327 cid:147'
    assert_equal false, PassportProcessing::COMPLETE_VALIDATOR.call(invalid_passport)
  end

  def test_passport_with_invalid_passport_id
    invalid_passport = 'pid:86003332 ecl:blu hcl:#123abc hgt:61in eyr:2020 iyr:2019 byr:1921 cid:147'
    assert_equal false, PassportProcessing::COMPLETE_VALIDATOR.call(invalid_passport)
  end

  def test_second_puzzle_solution
    assert_equal 188, PassportProcessing.count_valid_passports(validator: PassportProcessing::COMPLETE_VALIDATOR)
  end

  def test_count_valid_passport_complete_validator
    passport_filepath = './test/passport_file.txt'
    assert_equal 2, PassportProcessing.count_valid_passports(passport_filepath: passport_filepath, validator: PassportProcessing::COMPLETE_VALIDATOR)
  end

  def test_count_all_invalid_passport_complete_validator
    passport_filepath = './test/invalid_passport_file.txt'
    assert_equal 0, PassportProcessing.count_valid_passports(passport_filepath: passport_filepath, validator: PassportProcessing::COMPLETE_VALIDATOR)
  end

  def test_count_all_valid_passport_complete_validator
    passport_filepath = './test/valid_passport_file.txt'
    assert_equal 4, PassportProcessing.count_valid_passports(passport_filepath: passport_filepath, validator: PassportProcessing::COMPLETE_VALIDATOR)
  end

  def test_height_without_scale
    assert_equal false, PassportProcessing.validate_height('66')
  end

  def test_hair_color
    assert_equal false, PassportProcessing.validate_hair_color('#1')
    assert PassportProcessing.validate_hair_color('#123456')
    assert_equal false, PassportProcessing.validate_hair_color('#1234567')
  end
end
