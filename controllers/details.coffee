server = require('../app')
Detail = require('../models/detail').Detail
_ = require('underscore')

server.get('/details/:key.json', (req, res) ->
  key = req.params.key
  Detail.findOne( key: key )
    .run (err, detail) ->
      res.charset = 'utf-8'
      res.contentType('application/json')
      res.send(
        detail: detail
        success: true
      )
)
