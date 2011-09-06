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

heading = (depth) ->
  h = ''
  while depth-- > 0
    h += '#'
  h

renderItem = (item, result = [], depth = 1) ->
  if item.type is 'part'
    type = 'Part '
  else if item.type is 'schedule'
    type = 'Schedule '
  else
    type = ''
  if item.label
    label = "#{item.label}".replace(/\s/g, '')
  if item.heading
    if item.repealed
      item.heading += ' [repealed]'
    if label
      result.push("#{heading(depth)} #{type}#{label}: #{item.heading}\n")
    else
      result.push("#{heading(depth)} #{type}: #{item.heading}\n")
  if item.text
    if label
      result.push("__#{label}.__ #{item.text}\n")
    else
      result.push("#{item.text}\n")
  items = item.items or []
  for itm in items
    unless type
      renderItem(itm, result, depth + 1)
    else
      renderItem(itm, result, depth + 1)
  result

renderRevisions = (act) ->
  if act
    _.map(act.revisions, (revision) ->
      html: md(renderItem(revision).join('\n'))
      date_assent: revision.date_assent
      date_as_at: revision.date_as_at
      date_terminated: revision.date_terminated
      updated: revision.date_as_at || revision.date_assent || revision.date_terminated
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
    res.send(
      revisions: renderRevisions(act)
    )
  )
)
