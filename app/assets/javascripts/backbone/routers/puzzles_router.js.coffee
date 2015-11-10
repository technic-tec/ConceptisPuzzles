class ConceptisPuzzles.Routers.PuzzlesRouter extends Backbone.Router
  initialize: (options) ->
    @puzzles = new ConceptisPuzzles.Collections.PuzzlesCollection()
    @puzzles.reset options.puzzles

  routes:
    "new"      : "newPuzzle"
    "index"    : "index"
    "p:pg"     : "index"
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

  index: (pg)->
    @view = new ConceptisPuzzles.Views.Puzzles.IndexView(collection: @puzzles)
    $("#puzzles").html(@view.render().el)
    if pg is undefined or pg is null
      pg = 1
    @puzzles.fetch({data: {page: pg}, reset: true})

  show: (id) ->
    puzzle = @get_or_fetch(id)

    @view = new ConceptisPuzzles.Views.Puzzles.ShowView(model: puzzle)
    $("#puzzles").html(@view.render().el)

  edit: (id) ->
    puzzle = @get_or_fetch(id)

    @view = new ConceptisPuzzles.Views.Puzzles.EditView(model: puzzle)
    $("#puzzles").html(@view.render().el)
