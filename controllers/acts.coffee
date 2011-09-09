server = require('../app').server
Act = require('../models/act').ActModel
flow = require('flow')
_ = require('underscore')
sys = require('sys')
md = require('node-markdown').Markdown

slug = (s) -> (s || '').replace(/\s+/g, '-').replace(/[^a-zA-Z0-9-]/g, '').replace(/[-]+/g, '-').toLowerCase()

server.get('/', (req, res) ->
  res.render('index')
)

server.get '/acts.json', (req, res) ->
  start = req.query.start
  limit = req.query.limit
  query = req.query.q
  if query
    filters = _.map(query.split(/\s+/), (q) ->
      new RegExp(q, 'i')
    )
    filter =
      title:
        $all: filters
  else
    filter = {}

  flow.exec(
    (->
      Act.find(filter)
        .limit(limit)
        .desc('updated')
        .fields(['_id', 'updated', 'status', 'title'])
        .skip(start)
        .run(this)
    ),
    ((err, @acts) ->
      Act.count(filter, this)
    ),
    ((err, count) ->
      res.charset = 'utf-8'
      res.contentType('application/json')
      res.send(
        acts: @acts
        success: true
        totalCount: count
      )
    )
  )

capitalise = (s = '') ->
  "#{s.substring(0, 1).toUpperCase()}#{s.substring(1)}"

renderRevisions = (act) ->
  if act
    _.map(act.revisions, (revision) ->
      date_assent: revision.date_assent
      date_as_at: revision.date_as_at
      date_terminated: revision.date_terminated
      delta: revision.delta
      updated: revision.updated
      year: revision.year
      file_path: revision.file_path
      act_type: revision.act_type
      stage: revision.stage
      act_no: revision.act_no
    )
  else
    []

server.get('/acts/:id.json', (req, res) ->
  id = req.params.id
  Act.findById(id, (err, act) ->
    debugger
    res.send(
      revisions: renderRevisions(act)
    )
  )
)
