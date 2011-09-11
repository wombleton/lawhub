Ext.Loader.setConfig(enabled: true)
Ext.application(
  appFolder: 'js/app',
  controllers: [
    'Acts'
    'Governments'
  ]
  views: [
    'overview'
    'actlist'
    'acttab'
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
