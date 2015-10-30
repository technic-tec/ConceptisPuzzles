json.array!(@puzzles) do |puzzle|
  json.extract! puzzle, :id, :guid, :codeFamily, :codeVariant, :codeModel, :serialNumber, :versionMajor, :versionMinor, :builderVersion, :creationDate, :releaseDate, :properties, :data
  json.url puzzle_url(puzzle, format: :json)
end
