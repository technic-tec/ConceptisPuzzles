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
    url: null
    xml_url: null
    config_url: null
    save_url: null
    load_url: null
    family_name: null
    family_logic: null
    family_abbr: null
    family_background: null
    variant_name: null

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
  parse: (resp)->
    this.perPage = resp.per_page
    this.page = resp.page
    this.total = resp.total
    resp.puzzles
