_ = require('underscore')

class Item
  constructor: (@act, @id, @type) ->
    @items = []
    @text = ''
    @heading = ''
    @label = ''
  addSubprovision: () ->
    @act.currentStack.push(new Item(@act, undefined, 'subprovision'))
    @items.push(@act.currentNode())
  cleanup: ->
    delete @act
    _.each(@items, (item) -> item.cleanup())
    delete @items if @items.length is 0
    delete @text unless @text
    delete @heading unless @heading

module.exports.Item = Item
