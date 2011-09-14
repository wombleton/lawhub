server = require('../app')
Government = require('../models/government').Government
Revision = require('../models/revision').Revision
_ = require('underscore')
md = require('node-markdown').Markdown

server.get('/revisions/:key.json', (req, res) ->
  skip = req.query.start || 0
  limit = req.query.limit || 5
  key = req.params.key
  try
    filters = JSON.parse(req.query.filter)
    q = _.detect(filters, (filter) -> filter.property is 'q')?['value'] or ''
  catch e
    q = ''
  title = q.match(/title:\s*["'](.+?)["']/)?[1]
  keywords = q.replace(/title:\s*["'](.*?)["']/, '').match(/^\s*(.+?)\s*$/)?[1]
  re = new RegExp(keywords, 'i')

  Government.findById(key)
    .fields(['start', 'end'])
    .run (err, govt) ->
      if err
        console.log(err)
        throw err
      else
        start = govt.start
        end = govt.end

        find = {
          delta:
            $not:
              $size: 0
          updated:
            $gt: start
            $lt: end
        }
        if title
          find = _.extend(find,
            title: new RegExp(title, 'i')
          )
        if keywords
          find = _.extend(find,
            $or: [
              { 'delta.inserted': re }
              { 'delta.deleted': re }
            ]
          )

        res.charset = 'utf-8'
        res.contentType('application/json')
        Revision.find(find)
          .desc('updated')
          .skip(skip)
          .limit(limit)
          .fields(['title', 'delta', 'updated', 'file_path'])
          .run (err, revisions) ->
            if err
              console.log(err)
            else
              if keywords
                _.each(revisions, (revision) ->
                  revisions.delta = _.filter(revision.delta, (delta) ->
                    _.any(delta.inserted, (inserted) -> (inserted or '').match(re)) or _.any(delta.deleted, (deleted) -> (deleted or '').match(re))
                  )
                )
              revisions = _.map(revisions, (revision) ->
                deltas = _.map(revision.delta, (delta) ->
                  preamble = md(_.flatten(delta.preamble).join('\n'))
                  postscript = md(_.flatten(delta.postscript).join('\n'))
                  deleted = md(_.flatten(delta.deleted).join('\n'))
                  inserted = md(_.flatten(delta.inserted).join('\n'))
                  h = [preamble, "<div class=\"inserted\">#{inserted}</div>", "<div class=\"deleted\">#{deleted}</div>", postscript].join('')
                  "<div class=\"delta\">#{h}</div>"
                )

                file_path: revision.file_path
                html: deltas.join('')
                title: revision.title
                updated: revision.updated
              )
              Revision.count(find)
                .run (err, count) ->
                  res.send(
                    revisions: revisions
                    success: true
                    totalCount: count
                  )
)
