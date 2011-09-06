Ext.define('LH.view.act.List',
  afterRender: ->
    @textfield = @down('textfield[name=filter]')
  alias: 'widget.actlist'
  border: false
  extend: 'Ext.grid.Panel'
  initComponent: ->
    @columns = [
      {
        header: 'Title'
        dataIndex: 'title'
        flex: 1
      }
      {
        header: 'Year'
        dataIndex: 'year'
        flex: 1
      }
      {
        header: 'Status'
        dataIndex: 'status'
        flex: 1
      }
    ]
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
    @callParent(arguments)
    @store.guaranteeRange(0, 99)
    @getSelectionModel().on('select', (model, record) ->
      tab = @up('acttab')
      act = new LH.view.act.View(
        record: record
      )
      tab.add(act)
      tab.layout.setActiveItem(act)
    , @)
  onFilterChange: ->
    @store.filters.clear()
    @store.filter('title', @textfield.value)
  store: 'Acts'
  title: 'Acts'
  verticalScrollerType: 'paginggridscroller'
  invalidateScrollerOnRefresh: false
)
