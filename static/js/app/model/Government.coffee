Ext.define('LH.model.Government',
  extend: 'Ext.data.Model'
  fields: [
    '_id'
    'description'
    {
      name: 'start'
      type: 'date'
      convert: (v) ->
        new Date(v)
    }
    {
      name: 'end'
      type: 'date'
      convert: (v) ->
        new Date(v)
    }
    'inserted'
    'deleted'
  ]
)
