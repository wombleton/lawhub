server = require('../app')
Government = require('../models/government').Government
Revision = require('../models/revision').Revision
_ = require('underscore')

server.get('/governments.json', (req, res) ->
  Government.find()
      .asc('start')
      .fields(['_id', 'start', 'end', 'title'])
      .run (err, governments) ->
        res.charset = 'utf-8'
        res.contentType('application/json')
        res.send(
          governments: governments
          success: true
          totalCount: governments.length
        )
)

server.get('/governments/:id.json', (req, res) ->
  id = req.params.id
  Government.findById(id, (err, govt) ->
    Revision.find(
      {
        updated:
          $gt: govt.start
          $lt: govt.end
      }, (err, revisions) ->
        deltas = _.pluck(revisions, 'delta')
        blocks = _.flatten(deltas)
        deleted = _.compact(_.flatten(_.pluck(blocks, 'deleted'))).join('\n')
        inserted = _.compact(_.flatten(_.pluck(blocks, 'inserted'))).join('\n')

        res.charset = 'utf-8'
        res.contentType('application/json')
        res.send(
          deleted: deleted
          inserted: inserted
          success: true
        )
    )
  )
)
