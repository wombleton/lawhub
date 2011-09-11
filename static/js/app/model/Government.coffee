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
    'end'
    'inserted'
    'deleted'
  ]
)
