_ = require('underscore')
Item = require('./provision-parser').Item

class Act
  constructor: (attributes) ->
    @ids = []
    @items = []
    @stack = []
    @administeredBy = ''
    @currentStack = []
    @title = ''
  contains: (paths...) ->
    _.difference(paths, @stack).length is 0
  matches: (paths...) ->
    path = [].concat(@stack).reverse().join('::')
    _.any(paths, (p) -> path.indexOf(p) is 0)
  currentNode: ->
    @currentStack[@currentStack.length - 1]
  previousNode: ->
    @currentStack[@currentStack.length - 1]
  expand: (num, s = ' ') ->
    result = [' ']
    result.push(s) for i in [0..num]
    result.join('')
  count: (s) ->
    vals = _.filter(@stack, (val) ->
      val is s
    )
    vals.length
  openTag: (tag, attributes) ->
    switch tag
      when 'act'
        _.extend(@, attributes)
      when 'part'
        @addPart(attributes.id)
      when 'prov'
        if @matches('prov::body', 'prov::part::body')
          @addProvision(attributes.id)
          @currentNode().repealed = true if attributes['deletion_status'] is 'repealed'
        else if @matches('prov::amend')
          @addProvision(attributes.id, @previousNode() or @)
          @currentNode().repealed = true if attributes['deletion_status'] is 'repealed'
      when 'subprov'
        @currentNode()?.addSubprovision(attributes.id) unless attributes['deletion-status'] is 'repealed'
      when 'extref::citation::heading', 'intref::citation:heading'
        @currentNode()?.text += "(/byid/#{attributes['href']})" if attributes['href']
      when 'extref::citation::text', 'intref::citation::text', 'leg-title'
        @currentNode()?.text += "(/byid/#{attributes['href']})" if attributes['href']
      when 'atidlm:resourcepair'
        if @contains('heading')
          @currentNode()?.heading += "(/byid/#{attributes['atidlm_targetXmlId']})" if attributes['atidlm_targetXmlId']
        else if @contains('para', 'text')
          @currentNode()?.text += "(/byid/#{attributes['atidlm_targetXmlId']})" if attributes['atidlm_targetXmlId']
      when 'label-para'
        @currentNode()?.text += '\n' if @matches('label-para::para')
      when 'def-term'
        @currentNode()?.text += "(/byid/#{attributes.id})"
      when 'def-para'
        @currentNode()?.text += '\n * '
      when 'label'
        if attributes.denominator is 'yes' and @matches('label::label-para')
          @currentNode()?.text += "\n#{@expand(@count('label'))}* "
      when 'row'
        @currentNode()?.text += '\n' if @matches('row::tbody::tgroup::table')
  closeTag: (tag) ->
    switch tag
      when 'prov', 'subprov', 'part'
        @currentStack.pop()
      when 'text'
        @currentNode()?.text += '\n\n'

  acceptText: (s) ->
    if @matches('title::cover', 'insertwords::title::cover')
      @title += s
    unless @date_terminated
      if @matches('admin-office::cover.reprint-note')
        @administeredBy += s
      else if @matches('ministry::admin-office::cover.reprint-note')
        @administeredBy += "_#{s}_"
      # node amendments
      if node = @currentNode()
        if @matches('label::prov', 'label::subprov', 'label::part')
          node.label += s
        else if @matches('heading::part', 'heading::prov', 'insertwords::heading::prov', 'citation::heading::prov')
          node.heading += s
        else if @matches('quote.in::heading')
          node.heading += "__#{s}__"
        else if @matches('text::para', 'citation::text::para')
          node.text += s
        else if @matches('extref::citation', 'intref::citation', 'leg-title::citation::text::para', 'leg-title::citation::insertwords::text::para')
          node.text = node.text.replace(/(\(\/byid\/[^\)]+?\))$/, "[#{s}]$1")
        else if @matches('atidlm:linkcontent::atidlm:link')
          if @contains('heading')
            node.heading += "[#{s}]"
          else if @contains('para', 'text')
            node.text += "[#{s}]"
        else if @matches('quote.in::text::para', 'amend.in::text::para')
          node.text += "_#{s}_"
        else if @matches('emphasis')
          node.text += "_#{s}_"
        else if @matches('label::label-para')
          node.text += "#{s}) "
        else if @matches('def-term')
          node.text = node.text.replace(/(\(\/byid\/[^\)]+?\))$/, "__[#{s}]$1__")
        else if @matches('entry::row::tbody::tgroup::table')
          node.text += " #{s}"

  addId: (id) ->
    @ids.push(id) if id
  addPart: (id) ->
    @addId(id)
    @currentStack.push(new Item(@, id, 'part'))
    @items.push(@currentNode())
  addProvision: (id, target) ->
    @addId(id)
    target ?= @currentNode() or @
    @currentStack.push(new Item(@, id, 'provision'))
    console.log(target) unless target.items
    target.items.push(@currentNode())
  cleanup: ->
    delete @stack
    delete @currentStack
    if @date_terminated
      @items = []
    else
      _.each(@items, (item) -> item.cleanup())

module.exports =
  Act: Act
