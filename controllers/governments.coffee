server = require('../app')
Government = require('../models/government').Government
Revision = require('../models/revision').Revision
_ = require('underscore')

server.get('/governments.json', (req, res) ->
  debugger
  Government.find()
      .asc('start')
      .fields(['_id', 'description', 'start', 'end', 'inserted', 'deleted', 'theme'])
      .run (err, governments) ->
        res.charset = 'utf-8'
        res.contentType('application/json')
        res.send(
          governments: governments
          success: true
          totalCount: governments.length
        )
)

