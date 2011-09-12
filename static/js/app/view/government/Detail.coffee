Ext.define('LH.view.government.Detail',
  alias: 'widget.governmentdetail'
  border: false
  extend: 'Ext.panel.Panel'
  flex: 1
  layout:
    align: 'stretch'
    type: 'hbox'
  items: [
    {
      flex: 3
      xtype: 'teara'
    }
    {
      flex: 4
      xtype: 'snake'
    }
    {
      flex: 2
      xtype: 'keywords'
    }
  ]
)
