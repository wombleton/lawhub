mongoose = require('mongoose')
db = require('./db').db
fs = require('fs')
path = require('path')
flow = require('flow')
sax = require('./sax-js')
file = require('file')
_ = require('underscore')
actParser = require('./act-parser')
Act = actParser.Act
Schema = mongoose.Schema
ActModel = require('../models/act').ActModel
diff = require('./jsdifflib').diff

fixAttributes = (attributes) ->
  _.reduce(_.keys(attributes), (memo, key) ->
    newKey = key.replace(/[^\w]/g, '_')
    if newKey.indexOf('date_') is 0
      memo[newKey] = new Date(attributes[key]).getTime()
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

activeSaves = {}

saveAct = (act, filename) ->
  title = act.title
  unless activeSaves[title]
    activeSaves[title] = true
    ActModel.findOne({title: act.title}, (err, doc) ->
      if doc
        existingAct = doc
      else
        existingAct = new ActModel({title: act.title})
      revision = act
      delete revision.date_assent unless revision.date_assent
      revision.file_path = filename
      existingAct.revisions.push(revision)

      existingAct.revisions = _.sortBy(existingAct.revisions, (rev) ->
        rev.date_as_at or rev.date_first_valid
      )
      existingAct.save (err, doc) ->
        unless err
          flow.serialForEach(doc.revisions,
            (rev) ->
              if @curItem <= 1
                rev.updated = new Date(rev.date_assent or rev.date_first_valid)
                rev.delta = [
                  {
                    inserted: rev.markdown.split('\n')
                    deleted: []
                    preamble: []
                    postscript: []
                  }
                ]
              else
                rev.updated = new Date(rev.date_as_at or rev.date_first_valid)
                rev.delta = diff(doc.revisions[@curItem - 2].markdown, rev.markdown, context: 3)
              doc.save(@)
          , (err, d) ->
            debugger if err
            throw err if err
          , ->
            delete activeSaves[title]
          )
        else
          debugger
    )
  else
    console.log("Parse collision. Deferring parse one second for #{title}.")
    setTimeout(->
      saveAct(act, filename)
    , 1000)


module.exports.parse = (filename) ->
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
  saveAct(act, filename)

  return
