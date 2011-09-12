Ext.define('LH.store.Details',
  extend: 'Ext.data.Store'
  model: 'LH.model.Detail'
  proxy:
    buildUrl: (req) ->
      "/details/#{@record.get('_id')}.json"
    reader:
      type: 'json'
      root: 'detail'
      successProperty: 'success'
    type: 'ajax'
    url: '/details/key.json'
)
