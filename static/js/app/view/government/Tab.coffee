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
  initComponent: ->
    @callParent(arguments)

    @on('afterrender', ->
      [tabname, govt] = _.compact((Ext.History.getToken() or '').split('/'))
      tab = @query("##{tabname}")[0]
      @layout.setActiveItem(tab) if tab
      if tabname is 'govts' and govt
        store = Ext.StoreManager.get('Governments')
        store.on('load', ->
          record = store.getAt(govt - 1)
          if record
            strip = Ext.ComponentQuery.query('governmentstrip')[0]
            strip.react(record)

            list = Ext.ComponentQuery.query('revisionlist')[0]
            list.setUrl(record)
            teara = Ext.ComponentQuery.query('teara')[0]
            teara?.fetch(record)
            snake = Ext.ComponentQuery.query('snake')[0]
            snake?.fetch(record)
            keywords = Ext.ComponentQuery.query('keywords')[0]
            keywords?.fetch(record)
            govtsummaries = Ext.ComponentQuery.query('governmentsummary')
            _.each(govtsummaries, (summary) ->
              summary.setText(record)
            )
        , @, single: true)
    )
  updateHash: (tab) ->
    oldToken = Ext.History.getToken() or ''
    token = "/#{tab.id}"
    Ext.History.add(token) unless oldToken.indexOf(token) is 0

  items: [
    {
      id: 'intro'
      xtype: 'introduction'
    }
    {
      id: 'govts'
      xtype: 'governmentdetail'
    }
    {
      id: 'search'
      xtype: 'revisioncontainer'
    }
  ]
  flex: 1
  layout: 'card'
)

