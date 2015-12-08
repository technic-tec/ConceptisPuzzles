class ConceptisPuzzles.Routers.PuzzlesRouter extends Backbone.Router
  initialize: (options) ->
    @puzzles = new ConceptisPuzzles.Collections.PuzzlesCollection()
    @puzzles.reset options.puzzles

  routes:
    "new"      : "newPuzzle"
    "(f:family)(/)(v:variant)(/)(m:model)(/)(d:difficulty)(/)(p:pg)"     : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  get_or_fetch: (id)->
    puzzle = @puzzles.get(id)
    unless puzzle
      puzzle = new ConceptisPuzzles.Models.Puzzle({id: id})
      @puzzles.add(puzzle)
      puzzle.fetch()
    puzzle

  newPuzzle: ->
    @view = new ConceptisPuzzles.Views.Puzzles.NewView(collection: @puzzles)
    $("#puzzles").html(@view.render().el)

  index: (family, variant, model, difficulty, pg)->
    options = {}
    option_uri = ""
    if family
      options.family = family
      option_uri += "/f#{family}"
    if variant
      options.variant = variant
      option_uri += "/v#{variant}"
    if model
      options.model = model
      option_uri += "/m#{model}"
    if difficulty
      options.difficulty = difficulty
      option_uri += "/d#{difficulty}"
    if pg is undefined or pg is null
      pg = 1
    options.page = pg
    @view = new ConceptisPuzzles.Views.Puzzles.IndexView(collection: @puzzles, option_uri: option_uri, pg: pg, family: family)
    $("#puzzles").html(@view.render().el)
    @puzzles.fetch({data: options, reset: true})

  show: (id) ->
    puzzle = @get_or_fetch(id)

    @view = new ConceptisPuzzles.Views.Puzzles.ShowView(model: puzzle)
    $("#puzzles").html(@view.render().el)

  edit: (id) ->
    puzzle = @get_or_fetch(id)

    @view = new ConceptisPuzzles.Views.Puzzles.EditView(model: puzzle)
    $("#puzzles").html(@view.render().el)
