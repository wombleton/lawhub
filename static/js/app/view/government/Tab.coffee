Ext.define('LH.view.government.Tab'
  alias: 'widget.governmenttab'
  border: false
  extend: 'Ext.panel.Panel'
  setActive: (num) ->
    @get(1).setActiveTab(num)
  items: [
    {
      xtype: 'introduction'
    }
    {
      xtype: 'governmentdetail'
    }
    {
      xtype: 'revisionlist'
    }
  ]
  flex: 1
  layout: 'card'
)

