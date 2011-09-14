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
      _.each(records, (record, i) ->
        govt = new Ext.panel.Panel(
          cls: "lh-govt #{record.get('theme')}"
          flex: 1
          html: "#{i+1}"
          layout: 'fit'
          qtip: 'x'
          record: record
        )
        govt.on('render', (c) ->
          Ext.create('Ext.tip.ToolTip',
            target: c.body
            html: "#{record.get('description')}"
          )
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
