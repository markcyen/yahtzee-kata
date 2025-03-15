class YahtzeeScoring
  # TODO: think about initializing these variables
  # attr_reader :roll, :tally_roll
  # def initialize(roll)
  #   @roll = roll
  #   @tally_roll = @roll.tally
  #   @num_to_category = { 1 => :ones, 2 => :twos, 3 => :threes, 4 => :fours, 5 => :fives, 6 => :sixes }
  # end

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

  def self.score_upper_section

    # to get the highest, i want to multiple the keys and value and compare
    num, tally = @tally_roll.max_by { |k, v| k * v }
    best_score = num * tally
    best_category = @num_to_category[num]
 
    { category: best_category, score: best_score }
  end

  # TODO: integrate this into the main function and provide inline doc for each
  # so these can be deprecated
  def self.score_lower_section
    best_category = nil
    best_score = 0

    categories = [
      score_three_of_a_kind(),
      score_four_of_a_kind(),
      score_full_house(),
      score_small_straight(),
      score_large_straight(),
      score_yahtzee(),
      score_chance()
    ]

    categories.each do |result|
      if result[:score] > best_score
        best_score = result[:score]
        best_category = result[:category]
      end
    end

    { category: best_category, score: best_score }
  end

  def self.score_three_of_a_kind
    @tally_roll.value?(3) ? { category: :three_of_a_kind, score: @roll.sum } : { category: nil, score: 0 }
  end

  def self.score_four_of_a_kind
    @tally_roll.value?(4) ? { category: :four_of_a_kind, score: @roll.sum } : { category: nil, score: 0 }
  end

  def self.score_full_house
    counts = @tally_roll.values.sort
    counts == [2, 3] ? { category: :full_house, score: 25 } : { category: nil, score: 0 }
  end

  def self.score_small_straight
    unique_sorted = @roll.uniq.sort
    straights = [[1, 2, 3, 4], [2, 3, 4, 5], [3, 4, 5, 6]]
    straights.any? { |s| (s - unique_sorted).empty? } ? { category: :small_straight, score: 30 } : { category: nil, score: 0 }
  end

  def self.score_large_straight
    min, max = @roll.minmax
    (max - min == 4 && @roll.uniq.size == 5) ? { category: :large_straight, score: 40 } : { category: nil, score: 0 }
  end

  def self.score_yahtzee
    @roll.uniq.length == 1 ? { category: :yahtzee, score: 50 } : { category: nil, score: 0 }
  end

  def self.score_chance
    (!@tally_roll.value?(3) || !@tally_roll.value?(4)) ? { category: :chance, score: @roll.sum } : { category: nil, score: 0 }
  end
end

