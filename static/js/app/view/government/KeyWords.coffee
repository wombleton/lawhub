Ext.define('LH.view.government.KeyWords',
  alias: 'widget.keywords'
  autoScroll: true
  border: true
  extend: 'Ext.panel.Panel'
  layout: 'auto'
  title: 'Keywords'
  fetch: ->
    @removeAll()
    detail_store = Ext.StoreManager.get('Details')
    detail_store.on('datachanged', (s) ->
      records = s.getRange()
      tags = records[0]?.get('tags') or []
      _.each(tags, (tag, i) ->
        if i < 50
          @add(new Ext.button.Button(
            margin: 5
            text: tag.word
          ))
      , @)
    , @, single: true)
  margins: 8
)
