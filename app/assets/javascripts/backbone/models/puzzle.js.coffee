class ConceptisPuzzles.Models.Puzzle extends Backbone.Model
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

class ConceptisPuzzles.Collections.PuzzlesCollection extends Backbone.Collection
  model: ConceptisPuzzles.Models.Puzzle
  url: '/puzzles'
