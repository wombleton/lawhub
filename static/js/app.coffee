Ext.Loader.setConfig(enabled: true)
Ext.application(
  appFolder: 'js/app',
  controllers: [
    'Governments'
  ]
  views: [
    'overview'
  ]
  launch: ->
    Ext.create('Ext.container.Viewport',
      items: [
        {
          xtype: 'overview'
        }
      ]
      layout: 'fit'
    )
  name: 'LH'
)
