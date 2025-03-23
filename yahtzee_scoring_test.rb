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
    expected = {:three_of_a_kind => 21, :chance => 21}
    assert_equal(expected, YahtzeeScoring.best_score([6, 6, 6, 2, 1]))

    # Testing four of a kind and also getting three of a kind and chance having the best score as well
    expected = {:four_of_a_kind => 27, :three_of_a_kind => 27, :chance => 27}
    assert_equal(expected, YahtzeeScoring.best_score([6, 6, 6, 6, 3]))

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
    assert_equal({:threes => 6, :sixes => 6}, YahtzeeScoring.score_upper_section(largest_die_roll.tally))

    reality_roll = [2, 2, 4, 5, 6]
    assert_equal({:sixes => 6}, YahtzeeScoring.score_upper_section(reality_roll.tally))
  end

  def test_score_lower_section
    yahtzee_roll = [6, 6, 6, 6, 6]
    assert_equal({:yahtzee => 50}, YahtzeeScoring.score_lower_section(yahtzee_roll.tally))

    large_straight_roll = [1, 2, 3, 4, 5]
    assert_equal({:large_straight => 40}, YahtzeeScoring.score_lower_section(large_straight_roll.tally))

    small_straight_roll = [2, 2, 3, 4, 5]
    assert_equal({:small_straight => 30}, YahtzeeScoring.score_lower_section(small_straight_roll.tally))

    full_house_roll = [3, 3, 5, 5, 5]
    assert_equal({:full_house => 25}, YahtzeeScoring.score_lower_section(full_house_roll.tally))

    multiple_rolls = [3, 5, 5, 5, 5]
    expected = {:four_of_a_kind => 23, :three_of_a_kind => 23, :chance => 23}
    assert_equal(expected, YahtzeeScoring.score_lower_section(multiple_rolls.tally))

    three_of_a_kind_or_chance_roll = [5, 1, 5, 4, 5]
    expected = {:three_of_a_kind => 20, :chance => 20}
    assert_equal(expected, YahtzeeScoring.score_lower_section(three_of_a_kind_or_chance_roll.tally))

    chance_roll = [2, 1, 4, 4, 1]
    assert_equal({:chance => 12}, YahtzeeScoring.score_lower_section(chance_roll.tally))
  end
end
