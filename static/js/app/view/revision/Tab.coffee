Ext.define('LH.view.act.Tab',
  alias: 'widget.acttab'
  border: false
  doSearch: (el) ->
    @layout.setActiveItem(3)
  extend: 'Ext.panel.Panel'
  initComponent: ->
    @tbar = [
        handler: ->
          @layout.setActiveItem(0)
        scope: @
        text: 'Back'
        xtype: 'button'
      ' '
      'Lawhub'
    ]
    @callParent(arguments)
  items: [
    {
      xtype: 'actlist'
    }
  ]
  layout: 'card'
)
