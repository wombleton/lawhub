Ext.define('LH.view.government.Snake',
  alias: 'widget.snake'
  autoScroll: true
  border: true
  columns: [
    {
      header: 'Act'
      dataIndex: 'title'
      flex: 1
    }
    {
      header: 'Words Added'
      dataIndex: 'inserted'
    }
    {
      header: 'Words Removed'
      dataIndex: 'deleted'
    }
  ]
  extend: 'Ext.grid.Panel'
  fetch: (record) ->
    detail_store = Ext.StoreManager.get('Details')
    detail_store.on('load', (store, records) ->
      @store.removeAll()
      acts = records[0]?.get('acts')
      if acts
        @view.refresh()
        @store.add(acts)
        _.each(@store.getRange(), (r) ->
          r.commit()
        )
    , @)
    detail_store.proxy.record = record
    detail_store.load()
  layout: 'fit'
  title: false
  margins: 8
  store: 'ActDetails'
)
