Ext.define('LH.controller.Acts',
  extend: 'Ext.app.Controller'
  models: [
    'Act'
  ]
  stores: [
    'Acts'
  ]
  views: [
    'act.List'
    'act.Tab'
    'act.View'
    'act.Revision'
  ]
  init: ->
    @control(
      'viewport > panel':
        render: @onPanelRendered
    )
  onPanelRendered: ->
    #console.log('rendered!')
)
