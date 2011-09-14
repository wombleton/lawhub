Ext.define('LH.view.government.Strip',
  alias: 'widget.governmentstrip'
  border: false
  cls: 'lh-govt-strip'
  extend: 'Ext.panel.Panel'
  initComponent: ->
    @callParent(arguments)
    @addEvents('governmentselect')
    @store = Ext.data.StoreManager.get('Governments')
    @store.on('load', (store, records) ->
      _.each(records, (record) ->
        govt = new Ext.panel.Panel(
          cls: "lh-govt #{record.get('theme')}"
          flex: 1
          layout: 'fit'
          record: record
        )
        govt.on('render', (c) ->
          c.body.on('click', ->
            @react(c.record, c)
          , @)
        , @)
        @add(govt)
      , @)
    , @)
  react: (record, c) ->
    _.each(@items.getRange(), (item) ->
      item.removeCls('active')
    )
    c.addCls('active')
    @fireEvent('governmentselect', record)
  layout:
    align: 'stretch'
    type: 'hbox'
  padding: 8
)
