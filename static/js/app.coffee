Ext.Loader.setConfig(enabled: true)
Ext.application(
  appFolder: 'js/app',
  controllers: [
    'Acts'
  ]
  views: [
    'actlist'
    'acttab'
  ]
  launch: ->
    Ext.create('Ext.container.Viewport',
      items: [
        {
          xtype: 'acttab'
        }
      ]
      layout: 'fit'
    )
  name: 'LH'
)
