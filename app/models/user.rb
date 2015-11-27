class User < ActiveRecord::Base
  validates_uniqueness_of :uid,  :scope => :provider
  has_many :puzzle_saves
end
