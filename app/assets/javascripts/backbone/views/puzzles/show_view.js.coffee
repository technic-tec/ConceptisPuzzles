ConceptisPuzzles.Views.Puzzles ||= {}

class ConceptisPuzzles.Views.Puzzles.ShowView extends Backbone.View
  template: JST["backbone/templates/puzzles/show"]
  className: 'puzzle-container'

  initialize: () ->
    @model.bind('change', @render, this)

  render: ->
    $("#login-table").hide()
    @$el.html(@template(@model.toJSON() ))
    return this
