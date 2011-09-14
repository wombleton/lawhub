Ext.define('LH.view.revision.List',
  afterRender: ->
    @textfield = @down('textfield[name=filter]')
  alias: 'widget.revisionlist'
  extend: 'Ext.panel.Panel'
  initComponent: ->
    @tbar = [
      'Filter',
        hideLabel: true
        listeners:
          change:
            buffer: 500
            fn: @onFilterChange
            scope: @
        name: 'filter'
        width: 200
        xtype: 'textfield'
    ]
    @store = Ext.StoreManager.get('Revisions')
    @dockedItems = [
      {
        xtype: 'pagingtoolbar'
        store: @store
        dock: 'bottom'
        displayInfo: true
      }
    ]
    @panel = new Ext.panel.Panel(
      autoScroll: true
      layout: 'auto'
    )
    @items = @panel
    @callParent(arguments)
    @store.on('datachanged', @updateContent, @)
    @store.load()
  layout:
    type: 'fit'
  updateContent: (s) ->
    records = s.getRange()
    @panel.removeAll()
    _.each(records, (record) ->
      @panel.add(
        html: record.get('html')
        title: "#{record.get('title')} @ #{Ext.Date.format(record.get('updated'), 'j M Y')}"
        xtype: 'revisionview'
      )
    , @)
  onFilterChange: ->
    @panel.setLoading(true)
    @store.on('datachanged', ->
      @panel.setLoading(false)
    , @)
    @store.filters.clear()
    @store.filter('q', @textfield.value)
  title: 'omg'
)
