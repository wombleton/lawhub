Ext.define('LH.controller.Revisions',

  extend: 'Ext.app.Controller'
  models: [
    'Revision'
  ]
  stores: [
    'Revisions'
  ]
  views: [
    'revision.List'
  ]
)
