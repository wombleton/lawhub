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
      flex: 2
      xtype: 'teara'
    }
    {
      flex: 2
      xtype: 'snake'
    }
    {
      flex: 1
      xtype: 'keywords'
    }
  ]
)
