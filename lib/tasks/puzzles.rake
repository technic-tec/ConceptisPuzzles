namespace :puzzles do
  require 'nokogiri'
  require 'open-uri'
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
    ActiveRecord::Base.transaction {
      importPuzzle(open(filename))
    }
  end

  desc "import weekly puzzles from url"
  task :importWeekly, [:url, :cookie] => :environment do |t, args|
    unless args.url
      fail "Import url must be supplied"
    end
    importWeekly(args.url, args.cookie)
  end

  desc "import weekly puzzles in given date range"
  task :importFromTo, [:from, :to, :cookie] => :environment do |t, args|
    unless args.from
      fail "Import url must be supplied"
    end
    args.to = DateTime.now unless args.to
    d = DateTime.parse(args.from)
    dt = DateTime.parse(args.to)
    while d < dt
      url = 'http://www.conceptispuzzles.com/index.aspx?uri=myconceptis/weekly/'+d.strftime('%y%m%d')
      importWeekly(url, args.cookie)
      d += 7
    end
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

  def importWeekly(url, cookie)
    if cookie
      doc = Nokogiri.HTML(open(url, 'Cookie' => cookie))
    else
      doc = Nokogiri.HTML(open(url))
    end
    d = DateTime.parse(File.basename(URI.parse(url).query))
    pzs = doc.css('.myfam a').map { |p|
      u = URI.join(url, /'([^']+)'/.match(p.attribute('onclick'))[1])
      puts u
      doc1 = Nokogiri.HTML(open(u, 'Cookie' => cookie))
      flashVars = doc1.at_css('param[name="flashVars"]').attribute('value').to_s
      URI.join(url, CGI.parse(flashVars)['cafurl'][0])
    }
    ActiveRecord::Base.transaction {
      pzs.each { |u|
        puts u
        importPuzzle(open(u, 'Cookie' => cookie), publish_date=d)
      }
    }
  end

  def importPuzzle(fd, publish_date = nil)
    doc = Nokogiri.XML(fd)
    root = doc.root
    puzzle_cfg = {
      "publishDate" => publish_date,
      "data" => (root>"data").first.children.to_xml
    }
    (root>"header").first.element_children.each { |elem|
      if elem.name != 'properties'
        name = elem.name
        name = 'version' if name == 'formatVersion'
        elem.attributes.each { |key, attr|
          puzzle_cfg["#{name}_#{key}".camelize(:lower)] = attr.value
        }
        puzzle_cfg["#{name}"] = elem.text.strip if elem.text.strip != ''
      end
    }
    puzzle = Puzzle.create!(puzzle_cfg)
    (root>"header").first.element_children.each { |elem|
      if elem.name == 'properties'
        elem.element_children.each { |p|
          property = {"attr_type" => p.name, "puzzle_id" => puzzle.id}
          p.attributes.each { |key, attr|
            property[key] = attr.value
          }
          property["value"] ||= p.text
          Property.create! property
        }
      end
    }
    puzzle
  end
end
