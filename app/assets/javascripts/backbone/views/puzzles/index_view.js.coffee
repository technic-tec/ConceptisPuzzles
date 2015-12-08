ConceptisPuzzles.Views.Puzzles ||= {}

class ConceptisPuzzles.Views.Puzzles.IndexView extends Backbone.View
  template: JST["backbone/templates/puzzles/index"]
  className: "channel"

  initialize: (options) ->
    @collection.bind('reset', @addAll)
    @options = options

  addAll: () =>
    @$el.html(@template( puzzles: @collection.toJSON(), options: @options ))
    @collection.each(@addOne)

  addOne: (puzzle) =>
    view = new ConceptisPuzzles.Views.Puzzles.PuzzleView({model : puzzle})
    @$(".pagingbottom").before(view.render().el)

  render: =>
    @addAll()

    return this
