Ext.application(
  controllers: [
    'Governments'
    'Revisions'
  ]
  views: [
    'overview'
  ]
  launch: ->
    Ext.History.init()
    Ext.create('Ext.container.Viewport',
      items: [
        {
          xtype: 'overview'
        }
      ]
      layout:
        type: 'fit'
    )
  name: 'LH'
)
