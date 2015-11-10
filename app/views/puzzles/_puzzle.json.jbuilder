json.extract! puzzle, :id, :guid, :codeFamily, :codeVariant, :codeModel, :serialNumber, :versionMajor, :versionMinor, :builderVersion, :creationDate, :releaseDate, :properties, :data
json.url puzzle_url(puzzle, format: :json)
json.xml_url puzzle_path(puzzle, format: :xml)
json.config_url configure_puzzles_path(puzzle, format: :xml)
json.save_url save_puzzle_path(puzzle)
family = @puzzle_config.families['%02d' % puzzle.codeFamily]
json.family_name family.name
json.family_logic family.logic
json.family_abbr family.abbreviation
json.family_background family.background
json.variant_name family.variants[puzzle.codeVariant.to_s].name
