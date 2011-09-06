Ext.define('LH.view.act.View',
  alias: 'widget.actview'
  border: false
  extend: 'Ext.tab.Panel'
  initComponent: ->
    @callParent(arguments)
    @setTitle(@record.get('title'))
    @setLoading(true)
    Ext.Ajax.request(
      scope: @
      success: (response) ->
        obj = Ext.JSON.decode(response.responseText, true)
        _.each(obj.revisions, (revision) ->
          panel = {
            revision: revision
            xtype: 'revision'
          }
          @add(panel)
          #@add(new Ext.panel.Panel(
           # autoScroll: true
            #html: revision.html
          #  title: Ext.Date.format(new Date(revision.date_as_at), 'j M Y')
          #))
        , @)
        @setActiveTab(@items.length - 1)
        @setLoading(false)
      url: "/acts/#{@record.get('_id')}.json"
    )
)
