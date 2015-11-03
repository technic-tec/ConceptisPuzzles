json.page @page
json.per_page @perPage
json.total @total
json.puzzles do
  json.array!(@puzzles) do |puzzle|
    json.extract! puzzle, :id, :guid, :codeFamily, :codeVariant, :codeModel, :serialNumber, :versionMajor, :versionMinor, :builderVersion, :creationDate, :releaseDate, :properties, :data
    json.url puzzle_url(puzzle, format: :json)
  end
end
