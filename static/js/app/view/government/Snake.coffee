Ext.define('LH.view.government.Snake',
  alias: 'widget.snake'
  border: true
  columns: [
    {
      header: 'Act'
      dataIndex: 'description'
      flex: 1
    }
    {
      header: 'Words +/-'
      dataIndex: 'inserted_wordcount'
    }

  ]
  extend: 'Ext.grid.Panel'
  fetch: (record) ->
    debugger
  layout: 'fit'
  title: 'This is for "the snake" of legislation added and removed'
  margins: 8
  store: 'ActDetail'
)
