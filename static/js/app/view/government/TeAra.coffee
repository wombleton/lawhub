Ext.define('LH.view.government.TeAra',
  alias: 'widget.teara'
  autoScroll: true
  border: true
  extend: 'Ext.panel.Panel'
  fetch: (record) ->
    start = record.get('start')
    end = new Date(record.get('end'))
    tokens = []
    while start < end
      tokens.push(Ext.Date.format(start, 'Y'))
      start = Ext.Date.add(start, Ext.Date.YEAR, 1)
    @setLoading(true)
    Ext.Ajax.request(
      failure: ->
        @update('Whoops. Something went wrong.')
        @setLoading(false)
      url: "/teara/#{tokens.join(' ')}"
      scope: @
      success: (response) ->
        @update(response.responseText)
        @setLoading(false)
    )
  layout: 'fit'
  margins: 8
  title: 'This is for content from TeAra for the selected year'
)