ConceptisPuzzles.Views.Puzzles ||= {}

class ConceptisPuzzles.Views.Puzzles.IndexView extends Backbone.View
  template: JST["backbone/templates/puzzles/index"]

  initialize: () ->
    @collection.bind('reset', @addAll)

  addAll: () =>
    @collection.each(@addOne)

  addOne: (puzzle) =>
    view = new ConceptisPuzzles.Views.Puzzles.PuzzleView({model : puzzle})
    @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(puzzles: @collection.toJSON() ))
    @addAll()

    return this
