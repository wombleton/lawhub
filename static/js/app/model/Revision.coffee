Ext.define('LH.model.Revision',
  extend: 'Ext.data.Model'
  fields: [
    '_id'
    'title'
    {
      name: 'updated'
      type: 'date'
      convert: (v) ->
        new Date(v)
    }
    'html'
  ]
)
