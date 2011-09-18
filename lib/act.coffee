fs = require('fs')
flow = require('flow')
sax = require('./sax-js')
_ = require('underscore')
Act = require('./act-parser').Act
Revision = require('../models/revision').Revision
diff = require('./jsdifflib').diff

fixAttributes = (attributes) ->
  _.reduce(_.keys(attributes), (memo, key) ->
    newKey = key.replace(/[^\w]/g, '_')
    if newKey.indexOf('date_') is 0
      val = attributes[key]
      if val and val isnt 'nulldate'
        memo[newKey] = new Date(val).getTime()
    else unless key is 'xml:lang'
      memo[newKey] = attributes[key]
    memo
  , {})

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
      result.push("__#{label}.__ #{item.text}#{if item.repealed then ' [repealed]'}\n")
    else
      result.push("#{item.text}\n")

  items = item.items or []
  for itm in items
    unless type
      renderItem(itm, result, depth + 1)
    else
      renderItem(itm, result, depth + 1)
  result

activeSaves = {}

wait = 0

saveAct = (act, filename, cb) ->
  revision = new Revision(act)
  title = act.title
  unless activeSaves[title]
    activeSaves[title] = true
    Revision.find({title: title}, (err, revisions) ->
      revisions.push(revision)
      delete revision.date_assent unless revision.date_assent
      revision.file_path = filename

      sortedRevisions = _.sortBy(revisions, (rev) ->
        rev.date_as_at or rev.date_first_valid
      )
      flow.serialForEach(sortedRevisions,
        (rev) ->
          if @curItem <= 1
            rev.updated = rev.date_assent or rev.date_first_valid
            rev.delta = [
              {
                inserted: rev.markdown.split('\n')
                deleted: []
                preamble: []
                postscript: []
              }
            ]
          else
            rev.updated = rev.date_as_at or rev.date_first_valid
            previousMarkdown = sortedRevisions[@curItem - 2].markdown or ''
            previousMarkdown = previousMarkdown.replace(/\[(.+)\]\(.+?\)/g, '$1')
            markdown = rev.markdown or ''
            markdown = markdown.replace(/\[(.+)\]\(.+?\)/g, '$1')
            rev.delta = diff(previousMarkdown, markdown, context: 5)
          rev.save(@)
      , (err, d) ->
        debugger if err
        throw err if err
      , ->
        cb()
        delete activeSaves[title]
      )
    )
  else
    console.log("Parse collision. Deferring parse #{wait}ms for #{title}.")
    setTimeout(->
      saveAct(revision, filename, cb)
    , wait)
    wait = Math.floor(Math.random() * 2000) * 10

module.exports.parse = (filename, cb) ->
  f = fs.readFileSync(filename, 'utf8')
  parser = sax.parser()

  act = undefined

  parser.onopentag = (node) ->
    if node.name is 'ACT'
      act = new Act()
    if act
      tag = node.name.toLowerCase()
      act.stack.push(tag)
      act.openTag(tag, fixAttributes(node.attributes))

  parser.onclosetag = (tagname) ->
    act.stack.pop()
    act.closeTag(tagname.toLowerCase())

  parser.ontext = (t) ->
    act?.acceptText(t)

  parser.onend = ->
    act.cleanup()

  parser.write(f)
  parser.close()

  act.markdown = renderItem(act).join('\n')
  Revision.remove(
    file_path: filename
  ).run (err, removed) ->
    saveAct(act, filename, cb)

  return
