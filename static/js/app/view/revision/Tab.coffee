Ext.define('LH.view.act.Tab',
  alias: 'widget.acttab'
  border: false
  doSearch: (el) ->
    @layout.setActiveTab(3)
    debugger
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
