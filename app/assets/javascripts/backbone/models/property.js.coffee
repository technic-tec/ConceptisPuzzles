class ConceptisPuzzles.Models.Property extends Backbone.Model
  paramRoot: 'property'

  defaults:
    type: null
    name: null
    value: null
    unit: null
    puzzle_id: null

class ConceptisPuzzles.Collections.PropertiesCollection extends Backbone.Collection
  model: ConceptisPuzzles.Models.Property
  url: '/properties'
