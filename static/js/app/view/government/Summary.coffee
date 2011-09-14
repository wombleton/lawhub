Ext.define('LH.view.government.Summary',
  alias: 'widget.governmentsummary'
  border: false
  cls: 'governmentsummary'
  extend: 'Ext.panel.Panel'
  items: [
    {
      border: false
      flex: 1
    }
    {
      border: false
      flex: 1
    }
    {
      border: false
      flex: 3
    }
  ]
  layout:
    align: 'stretch'
    type: 'hbox'
  setText: (record) ->
    start = Ext.Date.format(record.get('start'), 'j M Y')
    end = Ext.Date.format(record.get('end'), 'j M Y')
    @items.get(0).update(record.get('description'))
    @items.get(1).update("#{start} - #{end}")
    @items.get(2).update("Added #{record.get('inserted')} lines of legislation")
  padding: '0 8'
)
