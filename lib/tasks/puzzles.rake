namespace :puzzles do
  desc "reset puzzle database"
  task :reset => :environment do
    File.open(Rails.root.join('config', 'puzzles.yml'), "a") { |f|
      f.truncate(0)
    }
    File.open(Rails.root.join('config', 'properties.yml'), "a") { |f|
      f.truncate(0)
    }
  end

  desc "import puzzles from xml files"
  task :import, [:filename] => :environment do |t, args|
    unless args.filename
      fail "Import file name must be supplied"
    end
    require 'yaml'
    require 'psych'
    require 'nokogiri'
    require 'open-uri'
    id = Puzzle.maximum(:id) || 0
    pid = Property.maximum(:id) || 0
    ActiveRecord::Base.transaction {
      id += 1
      doc = Nokogiri.XML(open(filename))
      root = doc.root
      puzzle = {
        "id" => id,
        "data" => (root>"data").first.children.to_xml
      }
      (root>"header").first.element_children.each { |elem|
        if elem.name == 'properties'
          elem.element_children.each { |p|
            pid += 1
            property = {"id" => pid, "attr_type" => p.name, "puzzle_id" => id}
            p.attributes.each { |key, attr|
              property[key] = attr.value
            }
            property["value"] ||= p.text
            Property.create! property
          }
        else
          name = elem.name
          name = 'version' if name == 'formatVersion'
          elem.attributes.each { |key, attr|
            puzzle["#{name}_#{key}".camelize(:lower)] = attr.value
          }
          puzzle["#{name}"] = elem.text.strip if elem.text.strip != ''
        end
      }
      Puzzle.create! puzzle
    }
  end

  desc "Solve puzzle"
  task :solve, [:puzzle_id] => :environment do |t, args|
    puzzle = Puzzle.find(args.puzzle_id)
    case puzzle.codeFamily
    when 9
      require './lib/solver/hit.rb'
      solver = HitSolver.new puzzle
    else
      puts "Not supported!"
      exit
    end
    solver.solve
  end
end
