class YahtzeeScoring
  @roll = []
  @tally_roll = {}

  def self.best_score(roll = [])
    @roll = roll
    @tally_roll = @roll.tally

    raise ArgumentError, "Error: The number of die being rolled should be five." if @roll.length != 5

    best = [score_upper_section, score_lower_section].max_by { |roll| roll[:score] }

    { category: best[:category], score: best[:score] }
  end

  # score_upper_section determines the best_category and best_score for the upper section
  def self.score_upper_section
    num_to_category = { 1 => :ones, 2 => :twos, 3 => :threes, 4 => :fours, 5 => :fives, 6 => :sixes }

    # This method gets the best score first by the frequency
    # If the score is tied, then this method gets the number and frequency by the highest dice number
    number, frequency = @tally_roll.max_by { |num, freq| [num * freq, num] }
    best_score = number * frequency
    best_category = num_to_category[number]
 
    { category: best_category, score: best_score }
  end

  # score_lower_section determines the best_category and best_score for the lower section
  def self.score_lower_section
    sum_roll = @roll.sum

    categories = []
    categories << { category: :yahtzee, score: 50 } if is_yahtzee?()
    categories << { category: :large_straight, score: 40 } if is_large_straight?()
    categories << { category: :small_straight, score: 30 } if is_small_straight?()
    categories << { category: :full_house, score: 25 } if is_full_house?()
    categories << { category: :four_of_a_kind, score: sum_roll } if is_four_of_a_kind?()
    categories << { category: :three_of_a_kind, score: sum_roll } if is_three_of_a_kind?()
    categories << { category: :chance, score: sum_roll }

    # If there are two scores that are equal, this function extracts the first one in the array
    best = categories.max_by { |roll| roll[:score] }

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
    counts = @tally_roll.values
    counts == [2, 3] || counts == [3, 2]
  end

  def self.is_four_of_a_kind?
    @tally_roll.values.any? { |v| v >= 4 }
  end

  def self.is_three_of_a_kind?
    @tally_roll.values.any? { |v| v >= 3 }
  end
  # ***********
end

