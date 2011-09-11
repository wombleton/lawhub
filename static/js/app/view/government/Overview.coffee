Ext.define('LH.view.government.Overview'
  alias: 'widget.overview'
  border: false
  extend: 'Ext.panel.Panel'
  padding: '0 100'
  items: [
    {
      border: false
      title: 'Total Legislation'
      xtype: 'panel'
      layout: 'fit'
      items:
        xtype: 'governmentgraph'
      height: 150
    }
    {
      height: 60
      xtype: 'governmentstrip'
    }
    {
      flex: 1
      xtype: 'governmentdetail'
    }
  ]
  layout:
    align: 'stretch'
    type: 'vbox'
)
