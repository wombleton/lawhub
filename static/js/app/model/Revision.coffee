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
    {
      name: 'file_path'
      dataIndex: 'file_path'
      convert: (v) ->
        "http://www.legislation.govt.nz/subscribe/#{v.match(/.*\/raw\/(.+\/).*/, '$1')[1]}"
    }
  ]
)
