server = require('../app')
Government = require('../models/government').Government
Revision = require('../models/revision').Revision
_ = require('underscore')
glossary = require('glossary')( minFreq: 10, verbose: true, collapse: true, blacklist: ['act', 'byidDLM', 'board', 'part', 'section', 'district', 'time', 'said', 'day', 'provision', 'respect', 'schedule'] )

server.get('/governments.json', (req, res) ->
  Government.find()
      .asc('start')
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

        keywords = glossary.extract(inserted.replace(/[^a-z0-9' -]/ig, ''))
        keywords = _.sortBy(keywords, (word) -> word.count)
        console.log(keywords)
        console.log(keywords.length)

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
