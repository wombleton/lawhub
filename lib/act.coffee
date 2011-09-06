mongoose = require('mongoose')
db = require('./db').db
fs = require('fs')
path = require('path')
sax = require('./sax-js')
file = require('file')
_ = require('underscore')
actParser = require('./act-parser')
Act = actParser.Act
Schema = mongoose.Schema
ActModel = require('../models/act').ActModel

fixAttributes = (attributes) ->
  _.reduce(_.keys(attributes), (memo, key) ->
    newKey = key.replace(/[^\w]/g, '_')
    if newKey.indexOf('date_') is 0
      memo[newKey] = new Date(attributes[key]).getTime()
    else unless key is 'xml:lang'
      memo[newKey] = attributes[key]
    memo
  , {})

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
      delete revision.title
      revision.file_path = filename
      revisions = existingAct.revisions
      revisions.push(revision)
      revisions = _.sortBy(revisions, (rev) ->
        rev.date_first_valid or rev.date_as_at
      )
      lastRevision = _.last(revisions)
      existingAct.updated = lastRevision?.date_as_at or lastRevision?.date_first_valid
      existingAct.status = lastRevision?.stage
      existingAct.save((err, doc) ->
        delete activeSaves[title]
      )
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

  saveAct(act, filename)

  return
