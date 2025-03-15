require "minitest/autorun"
require_relative "yahtzee_scoring"

class TestYahtzeeScoring < Minitest::Test
  def test_best_score
    
  end

  def test_best_score_roll_length_error
    assert_equal("Error: The number of die being rolled should only be five.", YahtzeeScoring.best_score([6, 6, 6, 2, 1, 3]))
  end

  def test_best_score_three_of_a_kind
    assert_equal({ category: :three_of_a_kind, score: 21 }, YahtzeeScoring.best_score([6, 6, 6, 2, 1]))
    assert_equal({ category: :three_of_a_kind, score: 16 }, YahtzeeScoring.best_score([5, 3, 3, 3, 2]))
  end

  def test_best_score_four_of_a_kind
    assert_equal({category: :four_of_a_kind, score: 27 }, YahtzeeScoring.best_score([6, 6, 6, 6, 3]))
    assert_equal({category: :four_of_a_kind, score: 16 }, YahtzeeScoring.best_score([3, 3, 4, 3, 3]))
  end

  def test_best_score_full_house
    assert_equal({ category: :full_house, score: 25 }, YahtzeeScoring.best_score([3, 3, 3, 5, 5]))
    assert_equal({ category: :full_house, score: 25 }, YahtzeeScoring.best_score([1, 2, 1, 2, 1]))
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
  end

  def test_best_score_yahtzee
    assert_equal({ category: :yahtzee, score: 50 }, YahtzeeScoring.best_score([6, 6, 6, 6, 6]))
    refute_equal({ category: :yahtzee, score: 50 }, YahtzeeScoring.best_score([6, 6, 6, 6, 1]))
  end

  def test_best_score_chance
    assert_equal({ category: :chance, score: 17 }, YahtzeeScoring.best_score([1, 2, 3, 5, 6]))
  end
end
