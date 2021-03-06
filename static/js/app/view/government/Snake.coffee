Ext.define('LH.view.government.Snake',
  alias: 'widget.snake'
  autoScroll: true
  border: true
  columns: [
    {
      header: 'Act'
      dataIndex: 'title'
      menuDisabled: true
      flex: 1
    }
    {
      header: 'Words Added'
      dataIndex: 'inserted'
      menuDisabled: true
    }
    {
      header: 'Words Removed'
      dataIndex: 'deleted'
      menuDisabled: true
    }
  ]
  extend: 'Ext.grid.Panel'
  fetch: (record) ->
    @setLoading(true)
    detail_store = Ext.StoreManager.get('Details')
    detail_store.on('datachanged', (store) ->
      @store.removeAll()
      records = store.getRange()
      acts = records[0]?.get('acts')
      if acts
        @view.refresh()
        @store.add(acts)
      @setLoading(false)
    , @)
    detail_store.proxy.record = record
    detail_store.load()
  layout: 'fit'
  title: 'Acts Affected'
  margins: 8
  store: 'ActDetails'
)
