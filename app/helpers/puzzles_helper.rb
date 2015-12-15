module PuzzlesHelper
  def puzzle_property(puzzle, attr)
    prop = puzzle.properties.where(:name => attr)
    if prop.any?
      prop.first.value
    else
      nil
    end
  end

  def puzzle_name(puzzle)
    puzzle_property(puzzle, "name")
  end

  def puzzle_difficulty(puzzle)
    puzzle_property(puzzle, "difficulty")
  end
end
