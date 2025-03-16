class YahtzeeScoring
  @roll = []
  @tally_roll = {}
  @num_to_category = { 1 => :ones, 2 => :twos, 3 => :threes, 4 => :fours, 5 => :fives, 6 => :sixes }

  def self.best_score(roll)
    @roll = roll

    return "Error: The number of die being rolled should only be five." if @roll.length != 5

    @tally_roll = @roll.tally

    best_category = nil
    best_score = 0

    score = score_upper_section
    if score[:score] > best_score
      best_score = score[:score]
      best_category = score[:category]
    end

    score = score_lower_section
    if score[:score] > best_score
      best_score = score[:score]
      best_category = score[:category]
    end

    { category: best_category, score: best_score }
  end

  # score_upper_section determines the best_category and best_score for the upper section
  def self.score_upper_section

    # This method gets the best score first by the value
    # If the value is tied, then it gets it by the highest key (or dice roll)
    num, frequency = @tally_roll.max_by { |k, v| [k * v, k] }
    best_score = num * frequency
    best_category = @num_to_category[num]
 
    { category: best_category, score: best_score }
  end

  # score_lower_section determines the best_category and best_score for the lower section
  def self.score_lower_section
    best_category = nil
    best_score = 0

    sum_roll = @roll.sum

    relevant_categories = []
    relevant_categories << { category: :yahtzee, score: 50 } if is_yahtzee?()
    relevant_categories << { category: :large_straight, score: 40 } if is_large_straight?()
    relevant_categories << { category: :small_straight, score: 30 } if is_small_straight?()
    relevant_categories << { category: :full_house, score: 25 } if is_full_house?()
    relevant_categories << { category: :four_of_a_kind, score: sum_roll } if is_four_of_a_kind?()
    relevant_categories << { category: :three_of_a_kind, score: sum_roll } if is_three_of_a_kind?()
    relevant_categories << { category: :chance, score: sum_roll } if !is_four_of_a_kind?() || !is_three_of_a_kind?()

    # max_by extracts the first one in the array if there are two scores that are the same
    best = relevant_categories.max_by { |roll| roll[:score] }

    { category: best[:category], score: best[:score] }
  end

  # Checks for lower section
  # ***********
  def self.is_yahtzee?
    @roll.uniq.length == 1
  end

  def self.is_large_straight?
    min, max = @roll.minmax
    max - min == 4 && @roll.uniq.size == 5
  end

  def self.is_small_straight?
    unique_sorted = @roll.uniq.sort
    straights = [[1, 2, 3, 4], [2, 3, 4, 5], [3, 4, 5, 6]]
    is_large_straight?() ? false : straights.any? { |s| (s - unique_sorted).empty? }
  end

  def self.is_full_house?
    counts = @tally_roll.values.sort
    counts == [2, 3]
  end

  def self.is_four_of_a_kind?
    @tally_roll.value?(4)
  end

  def self.is_three_of_a_kind?
    @tally_roll.value?(3)
  end
  # ***********
end

