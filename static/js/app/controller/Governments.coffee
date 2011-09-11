Ext.define('LH.controller.Governments',
  extend: 'Ext.app.Controller'
  init: ->
    @control(
      'governmentstrip':
        governmentselect: (record) ->
          teara = Ext.ComponentQuery.query('teara')[0]
          teara.fetch(record) if teara
    )
  models: [ 'Government' ]
  stores: [ 'Governments' ]
  views: [
    'government.Overview'
    'government.Detail'
    'government.Strip'
    'government.TeAra'
    'government.Snake'
    'government.KeyWords'
    'government.Graph'
  ]
)
