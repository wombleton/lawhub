Ext.define('LH.controller.Governments',
  extend: 'Ext.app.Controller'
  init: ->
    @control(
      'governmentstrip':
        governmentselect: (record) ->
          list = Ext.ComponentQuery.query('revisionlist')[0]
          list.setUrl(record)
          govttab = Ext.ComponentQuery.query('governmenttab')[0]
          govttab?.layout.setActiveItem(1)
          teara = Ext.ComponentQuery.query('teara')[0]
          teara?.fetch(record)
          snake = Ext.ComponentQuery.query('snake')[0]
          snake?.fetch(record)
          keywords = Ext.ComponentQuery.query('keywords')[0]
          keywords?.fetch(record)
          govtsummaries = Ext.ComponentQuery.query('governmentsummary')
          _.each(govtsummaries, (summary) ->
            summary.setText(record)
          )
      'keywords button':
        'click': (el) ->
          govttab = Ext.ComponentQuery.query('governmenttab')[0]
          govttab?.doSearch(el)
      'snake':
        'select': (el) ->
          govttab = Ext.ComponentQuery.query('governmenttab')[0]
          govttab?.doTitleSearch(el)
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
    'government.Summary'
  ]
)
