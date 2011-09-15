Ext.define('LH.view.government.Tab'
  alias: 'widget.governmenttab'
  border: false
  doTitleSearch: (el) ->
    @layout.setActiveItem(2)
    @query('revisionlist')[0].doSearch("title:\"#{el.lastSelected.get('title')}\"")
  doSearch: (el) ->
    @layout.setActiveItem(2)
    @query('revisionlist')[0].doSearch(el.text)
  extend: 'Ext.panel.Panel'
  items: [
    {
      xtype: 'introduction'
    }
    {
      xtype: 'governmentdetail'
    }
    {
      xtype: 'revisioncontainer'
    }
  ]
  flex: 1
  layout: 'card'
)

