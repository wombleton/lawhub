Ext.define('LH.view.government.Detail',
  alias: 'widget.governmentdetail'
  border: false
  extend: 'Ext.panel.Panel'
  flex: 1
  initComponent: ->
    @callParent(arguments)
    @on('activate', ->
      @findParentByType('governmenttab')?.updateHash(@)
    , @)
  layout:
    align: 'stretch'
    type: 'border'
  items: [
    {
      height: 36
      region: 'north'
      xtype: 'governmentsummary'
    }
    {
      flex: 3
      region: 'west'
      xtype: 'teara'
    }
    {
      flex: 4
      region: 'center'
      xtype: 'snake'
    }
    {
      flex: 2
      region: 'east'
      xtype: 'keywords'
    }
  ]
  padding: '0 8'
)
