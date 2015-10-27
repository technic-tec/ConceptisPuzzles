class ConceptisPuzzles.Routers.PuzzlesRouter extends Backbone.Router
  initialize: (options) ->
    @puzzles = new ConceptisPuzzles.Collections.PuzzlesCollection()
    @puzzles.reset options.puzzles

  routes:
    "new"      : "newPuzzle"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newPuzzle: ->
    @view = new ConceptisPuzzles.Views.Puzzles.NewView(collection: @puzzles)
    $("#puzzles").html(@view.render().el)

  index: ->
    @view = new ConceptisPuzzles.Views.Puzzles.IndexView(collection: @puzzles)
    $("#puzzles").html(@view.render().el)

  show: (id) ->
    puzzle = @puzzles.get(id)

    @view = new ConceptisPuzzles.Views.Puzzles.ShowView(model: puzzle)
    $("#puzzles").html(@view.render().el)

  edit: (id) ->
    puzzle = @puzzles.get(id)

    @view = new ConceptisPuzzles.Views.Puzzles.EditView(model: puzzle)
    $("#puzzles").html(@view.render().el)
