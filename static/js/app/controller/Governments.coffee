Ext.define('LH.controller.Governments',
  extend: 'Ext.app.Controller'
  init: ->
    @control(
      'governmentstrip':
        governmentselect: (record) ->
          govttab = Ext.ComponentQuery.query('governmenttab')[0]
          govttab?.layout.setActiveItem(1)
          teara = Ext.ComponentQuery.query('teara')[0]
          teara?.fetch(record)
          snake = Ext.ComponentQuery.query('snake')[0]
          snake?.fetch(record)
          keywords = Ext.ComponentQuery.query('keywords')[0]
          keywords?.fetch(record)
    )
  models: [ 'ActDetail', 'Detail', 'KeyWord', 'Government' ]
  stores: [ 'ActDetails', 'Details', 'KeyWords', 'Governments' ]
  views: [
    'government.Overview'
    'government.Detail'
    'government.Strip'
    'government.TeAra'
    'government.Snake'
    'government.KeyWords'
    'government.Graph'
    'government.Introduction'
    'government.Tab'
  ]
)
