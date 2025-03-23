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
    count_tally = tally_roll.values

    categories = {}
    if count_tally.any? { |count| count >= 3 }
      if count_tally.include?(5)
        categories[:yahtzee] = 50 
        return categories
      end

      categories[:four_of_a_kind] = sum_tally if count_tally.max >= 4
      categories[:three_of_a_kind] = sum_tally if count_tally.max >= 3
      categories[:full_house] = 25 if count_tally == [2, 3] || count_tally == [3, 2]
    end

    large_straight = [[1, 2, 3, 4, 5], [2, 3, 4, 5, 6]]
    small_straight = [[1, 2, 3, 4], [2, 3, 4, 5], [3, 4, 5, 6]]

    if tally_roll.keys.size >= 4
      categories[:large_straight] = 40 if large_straight.any? { |sequence| sequence.all? { |num| tally_roll.key?(num) } }
      categories[:small_straight] = 30 if small_straight.any? { |sequence| sequence.all? { |num| tally_roll.key?(num) } }
    end

    categories[:chance] = sum_tally

    highest_score = categories.values.max
    categories.select { |_, score| score == highest_score}
  end
end

