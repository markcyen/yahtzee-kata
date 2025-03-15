class YahtzeeScoring
  def self.best_score(roll)
    return "Error: The number of die being rolled should only be five." if roll.length != 5

    best_category = nil
    best_score = 0

    score = score_upper_section(roll)
    if score[:score] > best_score
      best_score = score[:score]
      best_category = score[:category]
    end

    score = score_lower_section(roll)
    if score[:score] > best_score
      best_score = score[:score]
      best_category = score[:category]
    end

    { category: best_category, score: best_score }
  end

  def self.score_upper_section(roll)
    best_category = nil
    best_score = 0

    (1..6).each do |num|
      score = roll.count(num) * num
      if score > best_score
        best_score = score
        best_category = num_to_category(num)
      end
    end
    { category: best_category, score: best_score }
  end

  def self.num_to_category(num)
    { 1 => :ones, 2 => :twos, 3 => :threes, 4 => :fours, 5 => :fives, 6 => :sixes }[num]
  end

  def self.score_lower_section(roll)
    best_category = nil
    best_score = 0

    categories = [
      score_three_of_a_kind(roll),
      score_four_of_a_kind(roll),
      score_full_house(roll),
      score_small_straight(roll),
      score_large_straight(roll),
      score_yahtzee(roll),
      score_chance(roll)
    ]

    categories.each do |result|
      if result[:score] > best_score
        best_score = result[:score]
        best_category = result[:category]
      end
    end

    { category: best_category, score: best_score }
  end

  def self.score_three_of_a_kind(roll)
    roll.tally.value?(3) ? { category: :three_of_a_kind, score: roll.sum } : { category: nil, score: 0 }
  end

  def self.score_four_of_a_kind(roll)
    roll.tally.value?(4) ? { category: :four_of_a_kind, score: roll.sum } : { category: nil, score: 0 }
  end

  def self.score_full_house(roll)
    counts = roll.tally.values.sort
    counts == [2, 3] ? { category: :full_house, score: 25 } : { category: nil, score: 0 }
  end

  def self.score_small_straight(roll)
    unique_sorted = roll.uniq.sort
    straights = [[1, 2, 3, 4], [2, 3, 4, 5], [3, 4, 5, 6]]
    straights.any? { |s| (s - unique_sorted).empty? } ? { category: :small_straight, score: 30 } : { category: nil, score: 0 }
  end

  def self.score_large_straight(roll)
    min, max = roll.minmax
    (max - min == 4 && roll.uniq.size == 5) ? { category: :large_straight, score: 40 } : { category: nil, score: 0 }
  end

  def self.score_yahtzee(roll)
    roll.uniq.length == 1 ? { category: :yahtzee, score: 50 } : { category: nil, score: 0 }
  end

  def self.score_chance(roll)
    tally_roll = roll.tally
    (!tally_roll.value?(3) || !tally_roll.value?(4)) ? { category: :chance, score: roll.sum } : { category: nil, score: 0 }
  end
end
