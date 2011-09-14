Ext.Loader.setConfig(enabled: true)
Ext.application(
  appFolder: 'js/app',
  controllers: [
    'Governments'
    'Revisions'
  ]
  views: [
    'overview'
    'revisionlist'
  ]
  launch: ->
    Ext.create('Ext.container.Viewport',
      items: [
        {
          xtype: 'revisionlist'
        }
      ]
      layout:
        type: 'fit'
    )
  name: 'LH'
)
