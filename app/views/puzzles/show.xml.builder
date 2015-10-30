xml.instruct!
xml.puzzle {
  xml.header {
    xml.guid @puzzle.guid
    xml.code("family" => "%02d" % @puzzle.codeFamily, "variant" => @puzzle.codeVariant,  "model" => @puzzle.codeModel)
    xml.serialNumber @puzzle.serialNumber
    xml.formatVersion("major" => @puzzle.versionMajor, "minor" => @puzzle.versionMinor)
    xml.builderVersion @puzzle.builderVersion
    xml.creationDate @puzzle.creationDate.strftime("%FT%TZ")
    xml.properties {
      @puzzle.properties.each {|p|
        if p.attr_type == "text"
          xml.tag!(p.attr_type, p.value, "name" => p.name)
        elsif p.unit
          xml.tag!(p.attr_type, "name" => p.name, "value" => p.value, "unit" => p.unit)
        else
          xml.tag!(p.attr_type, "name" => p.name, "value" => p.value)
        end
      }
    }
  }
  xml.data {
    xml << @puzzle.data
  }
}
