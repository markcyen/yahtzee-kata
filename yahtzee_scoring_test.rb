require "minitest/autorun"
require_relative "yahtzee_scoring"

class TestYahtzeeScoring < Minitest::Test
  def test_best_score_roll_length_error
    assert_equal("Error: The number of die being rolled should be five.", YahtzeeScoring.best_score([6, 6, 6, 2, 1, 3]))
    assert_equal("Error: The number of die being rolled should be five.", YahtzeeScoring.best_score([]))
    assert_equal("Error: The number of die being rolled should be five.", YahtzeeScoring.best_score())
  end

  def test_best_score_three_of_a_kind
    assert_equal({ category: :three_of_a_kind, score: 21 }, YahtzeeScoring.best_score([6, 6, 6, 2, 1]))
    assert_equal({ category: :three_of_a_kind, score: 16 }, YahtzeeScoring.best_score([5, 3, 3, 3, 2]))
    assert_equal({ category: :three_of_a_kind, score: 26 }, YahtzeeScoring.best_score([6, 6, 6, 4, 4]))
    refute_equal({ category: :full_house, score: 25 }, YahtzeeScoring.best_score([6, 6, 6, 4, 4]))
  end

  def test_best_score_four_of_a_kind
    assert_equal({category: :four_of_a_kind, score: 27 }, YahtzeeScoring.best_score([6, 6, 6, 6, 3]))
    assert_equal({category: :four_of_a_kind, score: 16 }, YahtzeeScoring.best_score([3, 3, 4, 3, 3]))
  end

  def test_best_score_full_house
    assert_equal({ category: :full_house, score: 25 }, YahtzeeScoring.best_score([3, 3, 3, 5, 5]))
    assert_equal({ category: :full_house, score: 25 }, YahtzeeScoring.best_score([1, 2, 1, 2, 1]))
    refute_equal({ category: :full_house, score: 25 }, YahtzeeScoring.best_score([6, 6, 6, 4, 4]))
  end

  def test_best_score_small_straight
    assert_equal({ category: :small_straight, score: 30 }, YahtzeeScoring.best_score([1, 3, 4, 5, 6]))
    assert_equal({ category: :small_straight, score: 30 }, YahtzeeScoring.best_score([5, 3, 2, 4, 5]))
    assert_equal({ category: :small_straight, score: 30 }, YahtzeeScoring.best_score([1, 2, 3, 4, 6]))
    refute_equal({ category: :small_straight, score: 30 }, YahtzeeScoring.best_score([2, 2, 4, 5, 6]))
  end

  def test_best_score_large_straight
    assert_equal({ category: :large_straight, score: 40 }, YahtzeeScoring.best_score([2, 3, 4, 5, 6]))
    assert_equal({ category: :large_straight, score: 40 }, YahtzeeScoring.best_score([1, 2, 3, 4, 5]))
    refute_equal({ category: :large_straight, score: 40 }, YahtzeeScoring.best_score([1, 2, 4, 5, 6]))

  end

  def test_best_score_yahtzee
    assert_equal({ category: :yahtzee, score: 50 }, YahtzeeScoring.best_score([6, 6, 6, 6, 6]))
    refute_equal({ category: :yahtzee, score: 50 }, YahtzeeScoring.best_score([6, 6, 6, 6, 1]))
  end

  def test_best_score_chance
    assert_equal({ category: :chance, score: 17 }, YahtzeeScoring.best_score([1, 2, 3, 5, 6]))
    assert_equal({ category: :chance, score: 22 }, YahtzeeScoring.best_score([2, 3, 5, 6, 6]))
  end

  def test_score_upper_section
    roll = [1, 3, 3, 3, 6]
    YahtzeeScoring.instance_variable_set(:@roll, roll)
    YahtzeeScoring.instance_variable_set(:@tally_roll, roll.tally)
    assert_equal({ category: :threes, score: 9 }, YahtzeeScoring.score_upper_section)

    largest_die_roll = [1, 3, 3, 5, 6]
    YahtzeeScoring.instance_variable_set(:@roll, largest_die_roll)
    YahtzeeScoring.instance_variable_set(:@tally_roll, largest_die_roll.tally)
    assert_equal({ category: :sixes, score: 6 }, YahtzeeScoring.score_upper_section)

    reality_roll = [2, 2, 4, 5, 6]
    YahtzeeScoring.instance_variable_set(:@roll, reality_roll)
    YahtzeeScoring.instance_variable_set(:@tally_roll, reality_roll.tally)
    assert_equal({ category: :sixes, score: 6 }, YahtzeeScoring.score_upper_section)
  end

  def test_score_lower_section
    yahtzee_roll = [6, 6, 6, 6, 6]
    YahtzeeScoring.instance_variable_set(:@roll, yahtzee_roll)
    YahtzeeScoring.instance_variable_set(:@tally_roll, yahtzee_roll.tally)
    assert_equal({ category: :yahtzee, score: 50 }, YahtzeeScoring.score_lower_section)

    large_straight_roll = [1, 2, 3, 4, 5]
    YahtzeeScoring.instance_variable_set(:@roll, large_straight_roll)
    assert_equal({ category: :large_straight, score: 40 }, YahtzeeScoring.score_lower_section)

    small_straight_roll = [2, 2, 3, 4, 5]
    YahtzeeScoring.instance_variable_set(:@roll, small_straight_roll)
    assert_equal({ category: :small_straight, score: 30 }, YahtzeeScoring.score_lower_section)

    full_house_roll = [3, 3, 5, 5, 5]
    YahtzeeScoring.instance_variable_set(:@roll, full_house_roll)
    YahtzeeScoring.instance_variable_set(:@tally_roll, full_house_roll.tally)
    assert_equal({ category: :full_house, score: 25 }, YahtzeeScoring.score_lower_section)

    four_of_a_kind_roll = [3, 5, 5, 5, 5]
    YahtzeeScoring.instance_variable_set(:@roll, four_of_a_kind_roll)
    YahtzeeScoring.instance_variable_set(:@tally_roll, four_of_a_kind_roll.tally)
    assert_equal({ category: :four_of_a_kind, score: 23 }, YahtzeeScoring.score_lower_section)

    three_of_a_kind_roll = [5, 1, 5, 4, 5]
    YahtzeeScoring.instance_variable_set(:@roll, three_of_a_kind_roll)
    YahtzeeScoring.instance_variable_set(:@tally_roll, three_of_a_kind_roll.tally)
    assert_equal({ category: :three_of_a_kind, score: 20 }, YahtzeeScoring.score_lower_section)

    chance_roll = [2, 1, 4, 4, 1]
    YahtzeeScoring.instance_variable_set(:@roll, chance_roll)
    YahtzeeScoring.instance_variable_set(:@tally_roll, chance_roll.tally)
    assert_equal({ category: :chance, score: 12 }, YahtzeeScoring.score_lower_section)

    # Edge cases:
    # Testing the best score when it could be three of a kind vs full house
    three_of_a_kind_vs_full_house_roll = [6, 6, 6, 4, 4]
    YahtzeeScoring.instance_variable_set(:@roll, three_of_a_kind_vs_full_house_roll)
    YahtzeeScoring.instance_variable_set(:@tally_roll, three_of_a_kind_vs_full_house_roll.tally)
    assert_equal({ category: :three_of_a_kind, score: 26 }, YahtzeeScoring.score_lower_section)

    # Testing when there are two best_scores, then choosing the first one (in order)
    four_of_a_kind_vs_chance_roll = [6, 6, 6, 6, 4]
    YahtzeeScoring.instance_variable_set(:@roll, four_of_a_kind_vs_chance_roll)
    YahtzeeScoring.instance_variable_set(:@tally_roll, four_of_a_kind_vs_chance_roll.tally)
    assert_equal({ category: :four_of_a_kind, score: 28 }, YahtzeeScoring.score_lower_section)
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
    assert_equal(false, YahtzeeScoring.is_four_of_a_kind?())
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
    assert_equal(false, YahtzeeScoring.is_three_of_a_kind?())

    yahtzee_roll = [3, 3, 3, 3, 3]
    YahtzeeScoring.instance_variable_set(:@tally_roll, yahtzee_roll.tally)
    assert_equal(false, YahtzeeScoring.is_three_of_a_kind?())
  end
end
