Ext.define('LH.view.government.Strip',
  alias: 'widget.governmentstrip'
  cls: 'lh-govt-strip'
  extend: 'Ext.panel.Panel'
  initComponent: ->
    @callParent(arguments)
    @addEvents('governmentselect')
    @store = Ext.data.StoreManager.get('Governments')
    @store.on('load', (store, records) ->
      _.each(records, (record) ->
        govt = new Ext.panel.Panel(
          border: false
          cls: 'lh-govt'
          flex: 1
          layout: 'fit'
          record: record
        )
        govt.on('render', (c) ->
          c.body.on('click', ->
            @react(c.record)
          , @)
        , @)
        @add(govt)
      , @)
    , @)
  react: (record) ->
    @fireEvent('governmentselect', record)
  layout:
    align: 'stretch'
    type: 'hbox'
  padding: 8
)
