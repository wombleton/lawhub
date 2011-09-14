Ext.define('LH.store.Revisions',
  buffered: true
  extend: 'Ext.data.Store'
  model: 'LH.model.Revision'
  pageSize: 5
  proxy:
    filterParam: 'q'
    encodeFilters: (filters) ->
      _.pluck(filters, 'value').join(' ')
    reader:
      type: 'json'
      root: 'revisions'
      successProperty: 'success'
      totalProperty: 'totalCount'
    type: 'ajax'
    url: '/revisions/key.json'
  remoteFilter: true
  remoteSort: true
)
