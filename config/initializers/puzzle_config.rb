require 'nokogiri'

class PuzzleConfig
  class Variant
    attr_reader :flags
    def initialize(variant)
      (variant>"genealogy").first.attributes.each {|key, val|
        self.instance_variable_set("@#{key}", val)
        Variant.class_eval{attr_reader key}
      }
      @flags = {}
      flag = (variant>"flags").first
      if(flag)
        flag.attributes.each {|key, val|
          @flags[key] = val
        }
      end
    end
  end

  class Family
    attr_reader :flags, :background, :variants
    def initialize(family)
      (family>"genealogy").first.attributes.each {|key, val|
        self.instance_variable_set("@#{key}", val)
        Family.class_eval{attr_reader key}
      }
      @flags = {}
      (family>"flags").first.attributes.each {|key, val|
        @flags[key] = val
      }
      @background = (family>"palette/color[name=\"background\"]").first.attr('rgb')
      @variants = {}
      (family>"variant").each {|variantNode|
        variant = Variant.new variantNode
        @variants[variant.code] = variant
      }
    end
  end

  attr_reader :doc, :families

  def initialize(fname)
    File.open(fname) { |f|
      @doc = Nokogiri.XML(f)
      @families = {}
      root = @doc.root
      (root>"family").each { |familyNode|
        family = Family.new familyNode
        @families[family.code] = family
      }
    }
  end
end

Rails.application.config.x.PUZZLE_CONFIG = PuzzleConfig.new(Rails.root.join('config', 'puzzle_config'))
