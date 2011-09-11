Ext.define('LH.store.Governments',
  extend: 'Ext.data.Store'
  model: 'LH.model.Government'
  pageSize: 100
  proxy:
    reader:
      type: 'json'
      root: 'governments'
      successProperty: 'success'
      totalProperty: 'totalCount'
    type: 'ajax'
    url: '/governments.json'
  sorters: [
    property: 'start'
    direction: 'ASC'
  ]
)
