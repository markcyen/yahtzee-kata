class YahtzeeScoring
  def self.best_score(roll)
    raise ArgumentError, "Error: The number of die being rolled should be five." if roll.length != 5
    tally_roll = roll.tally

    combined_sections = score_upper_section(tally_roll).merge(score_lower_section(roll))
    highest_score = combined_sections.values.max
    combined_sections.select { |category, score| score == highest_score}
  end

  # score_upper_section determines the best_category and best_score for the upper section
  # and returns a hash of of best categories that have the highest score
  def self.score_upper_section(tally_roll)
    num_to_category = { 1 => :ones, 2 => :twos, 3 => :threes, 4 => :fours, 5 => :fives, 6 => :sixes }

    best_scores = {}
    highest_score = tally_roll.map { |num, freq| num * freq }.max
    best_scores = tally_roll.select { |num, freq| num * freq == highest_score }
 
    best_scores.map { |num, freq| [num_to_category[num], num * freq] }.to_h
  end

  # score_lower_section determines the best_category and best_score for the lower section
  # and returns a hash of of best categories that have the highest score
  def self.score_lower_section(roll)
    tally_roll = roll.tally
    sum_roll = roll.sum

    categories = {}
    categories[:yahtzee] = 50 if is_yahtzee?(roll)
    categories[:large_straight] = 40 if is_large_straight?(roll)
    categories[:small_straight] = 30 if is_small_straight?(roll)
    categories[:full_house] = 25 if is_full_house?(tally_roll)
    categories[:four_of_a_kind] = sum_roll if is_four_of_a_kind?(tally_roll)
    categories[:three_of_a_kind] = sum_roll if is_three_of_a_kind?(tally_roll)
    categories[:chance] = sum_roll

    highest_score = categories.values.max
    categories.select { |category, score| score == highest_score}
  end

  # Checks for lower section categories
  # ***********
  def self.is_yahtzee?(roll)
    roll.uniq.length == 1
  end

  def self.is_large_straight?(roll)
    min, max = roll.minmax
    max - min == 4 && roll.uniq.size == 5
  end

  def self.is_small_straight?(roll)
    unique_sorted = roll.uniq.sort
    straights = [[1, 2, 3, 4], [2, 3, 4, 5], [3, 4, 5, 6]]
    straights.any? { |s| (s - unique_sorted).empty? }
  end

  def self.is_full_house?(tally_roll)
    counts = tally_roll.values.sort
    counts == [2, 3]
  end

  def self.is_four_of_a_kind?(tally_roll)
    tally_roll.values.any? { |v| v >= 4 }
  end

  def self.is_three_of_a_kind?(tally_roll)
    tally_roll.values.any? { |v| v >= 3 }
  end
  # ***********
end

