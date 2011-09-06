Ext.define('LH.store.Acts',
  buffered: true
  extend: 'Ext.data.Store'
  model: 'LH.model.Act'
  pageSize: 100
  proxy:
    filterParam: 'q'
    encodeFilters: (filters) ->
      _.pluck(filters, 'value').join(' ')
    reader:
      type: 'json'
      root: 'acts'
      successProperty: 'success'
      totalProperty: 'totalCount'
    type: 'ajax'
    url: '/acts.json'
  remoteFilter: true
  remoteSort: true
  sorters: [
    {
      property: 'updated'
      direction: 'DESC'
    }
  ]
)
