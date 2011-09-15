Ext.define('LH.view.revision.Container',
  alias: 'widget.revisioncontainer'
  border: false
  extend: 'Ext.panel.Panel'
  initComponent: ->
    @items = [
      {
        height: 30
        region: 'north'
        xtype: 'governmentsummary'
      }
      {
        flex: 1
        xtype: 'revisionlist'
      }
    ]
    @callParent(arguments)
    @on('activate', ->
      @findParentByType('governmenttab')?.updateHash(@)
    , @)
  layout:
    align: 'stretch'
    type: 'vbox'
)
