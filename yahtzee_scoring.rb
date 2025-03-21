class YahtzeeScoring
  def self.best_score(roll)
    raise ArgumentError, "Error: The number of die being rolled should be five." if roll.length != 5
    tally_roll = roll.tally

    combined_sections = score_upper_section(tally_roll)
    combined_sections.merge!(score_lower_section(tally_roll))
    highest_score = combined_sections.values.max
    combined_sections.select { |_, score| score == highest_score}
  end

  # score_upper_section determines the best_category and best_score for the upper section
  # and returns a hash of of best categories that have the highest score
  def self.score_upper_section(tally_roll)
    num_to_category = { 1 => :ones, 2 => :twos, 3 => :threes, 4 => :fours, 5 => :fives, 6 => :sixes }

    hash_scores = tally_roll.each_with_object({}) { |(num, freq), hash| hash[num_to_category[num]] = num * freq }
    highest_score = hash_scores.values.max
    hash_scores.select { |_, score| score == highest_score }
  end

  # score_lower_section determines the best_category and best_score for the lower section
  # and returns a hash of of best categories that have the highest score
  def self.score_lower_section(tally_roll)
    sum_tally = tally_roll.sum { |num, freq| num * freq }

    categories = {}
    if is_yahtzee?(tally_roll)
      categories[:yahtzee] = 50 
      return categories
    end

    categories[:large_straight] = 40 if is_large_straight?(tally_roll)
    categories[:small_straight] = 30 if is_small_straight?(tally_roll)
    categories[:full_house] = 25 if is_full_house?(tally_roll)
    categories[:four_of_a_kind] = sum_tally if is_four_of_a_kind?(tally_roll)
    categories[:three_of_a_kind] = sum_tally if is_three_of_a_kind?(tally_roll)
    categories[:chance] = sum_tally

    highest_score = categories.values.max
    categories.select { |_, score| score == highest_score}
  end

  # Checks for lower section categories
  # ***********
  def self.is_yahtzee?(tally_roll)
    tally_roll.values.include?(5)
  end

  def self.is_large_straight?(tally_roll)
    straights = [[1, 2, 3, 4, 5], [2, 3, 4, 5, 6]]

    straights.any? do |sequence|
      sequence.all? { |num| tally_roll.key?(num) }
    end
  end

  def self.is_small_straight?(tally_roll)
    straights = [[1, 2, 3, 4], [2, 3, 4, 5], [3, 4, 5, 6]]
    straights.any? do |sequence|
      sequence.all? { |num| tally_roll.key?(num) }
    end
  end

  def self.is_full_house?(tally_roll)
    counts = tally_roll.values
    counts == [2, 3] || counts == [3, 2]
  end

  def self.is_four_of_a_kind?(tally_roll)
    tally_roll.values.max >= 4
  end

  def self.is_three_of_a_kind?(tally_roll)
    tally_roll.values.max >= 3
  end
  # ***********
end

