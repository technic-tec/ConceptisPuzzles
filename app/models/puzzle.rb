class Puzzle < ActiveRecord::Base
  has_many :properties
  has_many :puzzle_saves
end
