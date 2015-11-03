ConceptisPuzzles.Views.Puzzles ||= {}

class ConceptisPuzzles.Views.Puzzles.IndexView extends Backbone.View
  template: JST["backbone/templates/puzzles/index"]

  initialize: () ->
    @collection.bind('reset', @addAll)

  addAll: () =>
    @$el.html(@template( puzzles: @collection.toJSON() ))
    @collection.each(@addOne)
    if @collection.page
      if @collection.page > 1
        @$("#prev-page").html($('<a />').attr('href', "#/p#{@collection.page-1}").text("Prev"))
      else
        @$("#prev-page").text("Prev")
      if @collection.page*@collection.perPage < @collection.total
        @$("#next-page").html($('<a />').attr('href', "#/p#{@collection.page+1}").text("Next"))
      else
        @$("#next-page").text("Next")

  addOne: (puzzle) =>
    view = new ConceptisPuzzles.Views.Puzzles.PuzzleView({model : puzzle})
    @$("tbody").append(view.render().el)

  render: =>
    @addAll()

    return this
