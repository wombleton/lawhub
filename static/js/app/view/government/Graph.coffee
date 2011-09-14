Ext.chart.theme.Legislation = Ext.extend(Ext.chart.theme.Base,
  constructor: (config) ->
    Ext.chart.theme.Base::constructor.call(@, Ext.apply(
        colors: [
          '#ff0000', '#00ff00'
        ]
    , config))
)


Ext.define('LH.view.government.Graph',
  alias: 'widget.governmentgraph'
  border: false
  extend: 'Ext.chart.Chart'
  initComponent: ->
    government_store = Ext.data.StoreManager.get('Governments')
    @store = new Ext.data.Store(
      fields: [ 'start', 'end', 'description', 'pm', 'total']
    )
    total = 0
    government_store.on('load', (s, records) ->
      Ext.getBody().unmask()
      _.each(records, (record) ->
        total += record.get('inserted')
        total -= record.get('deleted')
        @store.add(
          description: record.get('description')
          inserted: record.get('inserted')
          start: record.get('start')
          end: record.get('end')
          total: total
        )
      , @)
      last = _.last(records)
      @store.add(
        description: last.get('description')
        inserted: last.get('inserted')
        pm: 'Wonky Donky'
        start: last.get('end')
        end: last.get('end')
        total: total
      )
    , @)
    government_store.load()
    @callParent(arguments)

  series: [
    axis: 'left'
    highlight: true
    tips: {
      renderer: (record) ->
        start = Ext.Date.format(record.get('start'), 'j M Y')
        end = Ext.Date.format(record.get('end'), 'j M Y')
        this.setTitle("#{record.get('description')} #{start} - #{end}: Added #{record.get('inserted')} lines")
      width: 100
      trackMouse: true
    }
    type: 'area'
    xField: 'start'
    yField: [ 'total' ]
  ]
  label: 'Lines of legislation'
)
