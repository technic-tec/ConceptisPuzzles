class ConceptisPuzzles.Models.Puzzle extends Backbone.RelationalModel
  paramRoot: 'puzzle'

  defaults:
    guid: null
    codeFamily: null
    codeVariant: null
    codeModel: null
    serialNumber: null
    versionMajor: null
    versionMinor: null
    builderVersion: null
    creationDate: null
    releaseDate: null
    data: null

  relations: [
    type: Backbone.HasMany
    key: 'properties'
    relatedModel: 'ConceptisPuzzles.Models.Property'
    collectionType: 'ConceptisPuzzles.Collections.PropertiesCollection'
    includedInJSON: true
    reverseRelation:
      key: 'puzzle_id'
  ]

class ConceptisPuzzles.Collections.PuzzlesCollection extends Backbone.Collection
  model: ConceptisPuzzles.Models.Puzzle
  url: '/puzzles'
