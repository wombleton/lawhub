Ext.define('LH.store.Revisions',
  buffered: true
  extend: 'Ext.data.Store'
  model: 'LH.model.Revision'
  pageSize: 5
  proxy:
    reader:
      type: 'json'
      root: 'revisions'
      successProperty: 'success'
      totalProperty: 'totalCount'
    type: 'ajax'
    url: '/revisions/4e6e09d3ce6911bd1a000034.json'
  remoteFilter: true
  remoteSort: true
)
