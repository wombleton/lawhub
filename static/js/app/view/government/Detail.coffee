Ext.define('LH.view.government.Detail',
  alias: 'widget.governmentdetail'
  border: false
  extend: 'Ext.panel.Panel'
  flex: 1
  layout:
    align: 'stretch'
    type: 'border'
  items: [
    {
      region: 'west'
      xtype: 'teara'
    }
    {
      region: 'center'
      xtype: 'snake'
    }
    {
      region: 'east'
      xtype: 'keywords'
    }
  ]
)
