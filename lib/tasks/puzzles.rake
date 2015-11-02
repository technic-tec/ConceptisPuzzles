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
  task :import, [:filenames] => :environment do |t, args|
    unless args.filenames
      fail "Import file name must be supplied"
    end
    require 'yaml'
    require 'psych'
    require 'nokogiri'
    id = 0
    pid = 0
    File.open(Rails.root.join('config', 'puzzles.yml')) { |f|
      Psych.load_stream(f) {|doc|
        id += 1
      }
    }
    File.open(Rails.root.join('config', 'properties.yml')) { |f|
      Psych.load_stream(f) {|doc|
        pid += 1
      }
    }
    File.open(Rails.root.join('config', 'puzzles.yml'), "a") { |fplz|
      File.open(Rails.root.join('config', 'properties.yml'), "a") { |fpro|
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
                property["value"] ||= p.text
                YAML.dump(property, fpro)
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
          YAML.dump(puzzle, fplz)
        }
      }
    }
  end

end
