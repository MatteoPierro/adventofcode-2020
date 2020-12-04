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

end
