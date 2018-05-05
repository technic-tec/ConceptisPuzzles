# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'active_record/fixtures'
#File.open(Rails.root.join('config', 'puzzles.yml')) { |f|
#  ActiveRecord::Base.transaction {
#    Psych.load_stream(f) {|doc|
#      Puzzle.create! doc
#    }
#  }
#}
#File.open(Rails.root.join('config', 'properties.yml')) { |f|
#  ActiveRecord::Base.transaction {
#    Psych.load_stream(f) {|doc|
#      Property.create! doc
#    }
#  }
#}
