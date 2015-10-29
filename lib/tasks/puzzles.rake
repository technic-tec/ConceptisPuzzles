namespace :puzzles do
  desc "reset puzzle database"
  task :reset => :environment do
    File.open(Rails.root.join('config', 'puzzles.yml'), "a") { |f|
      f.truncate(0)
      f.close()
    }
    File.open(Rails.root.join('config', 'properties.yml'), "a") { |f|
      f.truncate(0)
      f.close()
    }
  end

  desc "import puzzles from xml files"
  task :import, [:filenames] => :environment do |t, args|
    unless args.filenames
      fail "Import file name must be supplied"
    end
    require 'yaml'
    require 'nokogiri'
    id = (YAML.load_file(Rails.root.join('config', 'puzzles.yml')) || {}).size
    pid = (YAML.load_file(Rails.root.join('config', 'properties.yml')) || {}).size
    puzzles = {}
    properties = {}
    Dir.glob(args[:filenames]) {|filename|
      id += 1
      doc = Nokogiri.XML(File.read(filename))
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
            properties["prop#{pid}"] = property
          }
        else
          name = elem.name
          name = 'version' if name == 'formatVersion'
          elem.attributes.each { |key, attr|
            puzzle["#{name}_#{key}".camelize] = attr.value
          }
          puzzle["#{name}"] = elem.text.strip if elem.text.strip != ''
        end
      }
      puzzles['puzzle#{id}'] = puzzle
    }
    File.open(Rails.root.join('config', 'puzzles.yml'), "a") { |f|
      YAML.dump(puzzles, f)
      f.close()
    }
    File.open(Rails.root.join('config', 'properties.yml'), "a") { |f|
      YAML.dump(properties, f)
      f.close()
    }
  end

end
