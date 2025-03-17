require "minitest/autorun"
require_relative "yahtzee_scoring"

class TestYahtzeeScoring < Minitest::Test
  def test_best_score_raises_error_for_incorrect_roll_length_input
    assert_raises(ArgumentError, "Error: The number of die being rolled should be five.") { YahtzeeScoring.best_score([6, 6, 6, 2, 1, 3]) }
    assert_raises(ArgumentError, "Error: The number of die being rolled should be five.") { YahtzeeScoring.best_score([]) }
    assert_raises(ArgumentError, "Error: The number of die being rolled should be five.") { YahtzeeScoring.best_score() }
  end

  def test_best_score
    # Testing three of a kind but getting chance as having the best score as well
    actual = {:three_of_a_kind => 21, :chance => 21}
    assert_equal(actual, YahtzeeScoring.best_score([6, 6, 6, 2, 1]))

    # Testing four of a kind and also getting three of a kind and chance having the best score as well
    actual = {:four_of_a_kind => 27, :three_of_a_kind => 27, :chance => 27}
    assert_equal(actual, YahtzeeScoring.best_score([6, 6, 6, 6, 3]))

    # Testing full house
    assert_equal({:full_house => 25}, YahtzeeScoring.best_score([3, 3, 3, 5, 5]))

    # Testing small straight
    assert_equal({:small_straight => 30}, YahtzeeScoring.best_score([1, 3, 4, 5, 6]))

    # Testing large straight
    assert_equal({:large_straight => 40}, YahtzeeScoring.best_score([2, 3, 4, 5, 6]))    

    # Testing Yahtzee
    assert_equal({:yahtzee => 50}, YahtzeeScoring.best_score([6, 6, 6, 6, 6]))

    # Testing chance
    assert_equal({:chance => 17}, YahtzeeScoring.best_score([1, 2, 3, 5, 6]))
  end

  def test_score_upper_section
    largest_die_roll = [1, 3, 3, 5, 6]
    YahtzeeScoring.instance_variable_set(:@roll, largest_die_roll)
    YahtzeeScoring.instance_variable_set(:@tally_roll, largest_die_roll.tally)
    assert_equal({:threes => 6, :sixes => 6}, YahtzeeScoring.score_upper_section)

    reality_roll = [2, 2, 4, 5, 6]
    YahtzeeScoring.instance_variable_set(:@roll, reality_roll)
    YahtzeeScoring.instance_variable_set(:@tally_roll, reality_roll.tally)
    assert_equal({:sixes => 6}, YahtzeeScoring.score_upper_section)
  end

  def test_score_lower_section
    yahtzee_roll = [6, 6, 6, 6, 6]
    YahtzeeScoring.instance_variable_set(:@roll, yahtzee_roll)
    YahtzeeScoring.instance_variable_set(:@tally_roll, yahtzee_roll.tally)
    assert_equal({:yahtzee => 50}, YahtzeeScoring.score_lower_section)

    large_straight_roll = [1, 2, 3, 4, 5]
    YahtzeeScoring.instance_variable_set(:@roll, large_straight_roll)
    assert_equal({:large_straight => 40}, YahtzeeScoring.score_lower_section)

    small_straight_roll = [2, 2, 3, 4, 5]
    YahtzeeScoring.instance_variable_set(:@roll, small_straight_roll)
    assert_equal({:small_straight => 30}, YahtzeeScoring.score_lower_section)

    full_house_roll = [3, 3, 5, 5, 5]
    YahtzeeScoring.instance_variable_set(:@roll, full_house_roll)
    YahtzeeScoring.instance_variable_set(:@tally_roll, full_house_roll.tally)
    assert_equal({:full_house => 25}, YahtzeeScoring.score_lower_section)

    multiple_rolls = [3, 5, 5, 5, 5]
    YahtzeeScoring.instance_variable_set(:@roll, multiple_rolls)
    YahtzeeScoring.instance_variable_set(:@tally_roll, multiple_rolls.tally)
    actual = {:four_of_a_kind => 23, :three_of_a_kind => 23, :chance => 23}
    assert_equal(actual, YahtzeeScoring.score_lower_section)

    three_of_a_kind_or_chance_roll = [5, 1, 5, 4, 5]
    YahtzeeScoring.instance_variable_set(:@roll, three_of_a_kind_or_chance_roll)
    YahtzeeScoring.instance_variable_set(:@tally_roll, three_of_a_kind_or_chance_roll.tally)
    actual = {:three_of_a_kind => 20, :chance => 20}
    assert_equal(actual, YahtzeeScoring.score_lower_section)

    chance_roll = [2, 1, 4, 4, 1]
    YahtzeeScoring.instance_variable_set(:@roll, chance_roll)
    YahtzeeScoring.instance_variable_set(:@tally_roll, chance_roll.tally)
    assert_equal({:chance => 12}, YahtzeeScoring.score_lower_section)
  end

  # Unit testing
  def test_is_yahtzee?
    yahtzee_roll = [1, 1, 1, 1, 1]
    YahtzeeScoring.instance_variable_set(:@roll, yahtzee_roll)
    assert_equal(true, YahtzeeScoring.is_yahtzee?())

    not_yahtzee_roll = [1, 1, 1, 1, 2]
    YahtzeeScoring.instance_variable_set(:@roll, not_yahtzee_roll)
    assert_equal(false, YahtzeeScoring.is_yahtzee?())
  end

  def test_is_large_straight?
    large_straight_front_roll = [1, 2, 3, 4, 5]
    YahtzeeScoring.instance_variable_set(:@roll, large_straight_front_roll)
    assert_equal(true, YahtzeeScoring.is_large_straight?())

    large_straight_back_roll = [2, 3, 4, 5, 6]
    YahtzeeScoring.instance_variable_set(:@roll, large_straight_back_roll)
    assert_equal(true, YahtzeeScoring.is_large_straight?())

    not_large_straight_roll = [1, 1, 1, 1, 2]
    YahtzeeScoring.instance_variable_set(:@roll, not_large_straight_roll)
    assert_equal(false, YahtzeeScoring.is_large_straight?())
  end

  def test_is_small_straight?
    small_straight_front_roll = [1, 2, 3, 4, 6]
    YahtzeeScoring.instance_variable_set(:@roll, small_straight_front_roll)
    assert_equal(true, YahtzeeScoring.is_small_straight?())

    small_straight_middle_roll = [2, 2, 3, 4, 5]
    YahtzeeScoring.instance_variable_set(:@roll, small_straight_middle_roll)
    assert_equal(true, YahtzeeScoring.is_small_straight?())

    small_straight_back_roll = [1, 3, 4, 5, 6]
    YahtzeeScoring.instance_variable_set(:@roll, small_straight_back_roll)
    assert_equal(true, YahtzeeScoring.is_small_straight?())

    not_small_straight_roll = [1, 2, 3, 4, 5]
    YahtzeeScoring.instance_variable_set(:@roll, not_small_straight_roll)
    assert_equal(false, YahtzeeScoring.is_small_straight?())
  end

  def test_is_full_house?
    full_house_roll = [2, 3, 3, 2, 3]
    YahtzeeScoring.instance_variable_set(:@tally_roll, full_house_roll.tally)
    assert_equal(true, YahtzeeScoring.is_full_house?())

    full_house_again_roll = [4, 6, 4, 6, 4]
    YahtzeeScoring.instance_variable_set(:@tally_roll, full_house_again_roll.tally)
    assert_equal(true, YahtzeeScoring.is_full_house?())

    not_full_house_roll = [4, 3, 3, 2, 3]
    YahtzeeScoring.instance_variable_set(:@tally_roll, not_full_house_roll.tally)
    assert_equal(false, YahtzeeScoring.is_full_house?())
  end

  def test_is_four_of_a_kind?
    four_of_a_kind_roll = [2, 3, 3, 3, 3]
    YahtzeeScoring.instance_variable_set(:@tally_roll, four_of_a_kind_roll.tally)
    assert_equal(true, YahtzeeScoring.is_four_of_a_kind?())

    not_four_of_a_kind_roll = [2, 2, 3, 3, 3]
    YahtzeeScoring.instance_variable_set(:@tally_roll, not_four_of_a_kind_roll.tally)
    assert_equal(false, YahtzeeScoring.is_four_of_a_kind?())

    yahtzee_roll = [3, 3, 3, 3, 3]
    YahtzeeScoring.instance_variable_set(:@tally_roll, yahtzee_roll.tally)
    assert_equal(true, YahtzeeScoring.is_four_of_a_kind?())
  end

  def test_is_three_of_a_kind?
    three_of_a_kind_roll = [5, 1, 3, 3, 3]
    YahtzeeScoring.instance_variable_set(:@tally_roll, three_of_a_kind_roll.tally)
    assert_equal(true, YahtzeeScoring.is_three_of_a_kind?())

    not_three_of_a_kind_roll = [5, 1, 2, 3, 3]
    YahtzeeScoring.instance_variable_set(:@tally_roll, not_three_of_a_kind_roll.tally)
    assert_equal(false, YahtzeeScoring.is_three_of_a_kind?())

    four_of_a_kind_roll = [2, 3, 3, 3, 3]
    YahtzeeScoring.instance_variable_set(:@tally_roll, four_of_a_kind_roll.tally)
    assert_equal(true, YahtzeeScoring.is_three_of_a_kind?())

    yahtzee_roll = [3, 3, 3, 3, 3]
    YahtzeeScoring.instance_variable_set(:@tally_roll, yahtzee_roll.tally)
    assert_equal(true, YahtzeeScoring.is_three_of_a_kind?())
  end
end
