Ext.define('LH.view.act.Revision',
  alias: 'widget.revision'
  align: 'stretch'
  border: false
  extend: 'Ext.panel.Panel'
  initComponent: ->
    @title = Ext.Date.format(new Date(@revision.updated), 'j M Y')
    if @revision.date_terminated
      @title += ' (Repealed)'
      @status = 'Repealed'
    else
      @status = 'In force'

    @callParent(arguments)
    @add(
      autoScroll: true
      border: false
      html: @revision.html
      padding: 10
      region: 'center'
      xtype: 'panel'
    )
    @add(
      border: false
      fieldDefaults:
        labelAlign: 'right'
      items: [
        {
          fieldLabel: 'Path'
          listeners:
            focus: ->
              @inputEl.dom.select()
              false
          value: @revision.file_path
          width: 600
          xtype: 'textfield'
        }
        {
          fieldLabel: 'Assented'
          value: if @revision.date_assent then Ext.Date.format(new Date(@revision.date_assent), 'j M Y') else ''
          xtype: 'displayfield'
        }
        {
          fieldLabel: 'Date As At'
          value: if @revision.date_as_at then Ext.Date.format(new Date(@revision.date_as_at), 'j M Y') else ''
          xtype: 'displayfield'
        }
        {
          fieldLabel: 'Date Updated'
          value: if @revision.udpated then Ext.Date.format(new Date(@revision.updated), 'j M Y') else ''
          xtype: 'displayfield'
        }
        {
          fieldLabel: 'Status'
          value: @status
          xtype: 'displayfield'
        }
        {
          fieldLabel: 'Year'
          value: @revision.year
          xtype: 'displayfield'
        }
      ]
      region: 'north'
      xtype: 'form'
    )
  layout: 'border'
)
