db = require('../db').db
mongoose = require('mongoose')
Schema = mongoose.Schema
dateformat = require('dateformat')
md = require('node-markdown').Markdown
_ = require('underscore')

slug = (s) -> (s || '').replace(/\s+/g, '-').replace(/[^a-zA-Z0-9-]/g, '').replace(/[-]+/g, '-').toLowerCase()

parseTags = (tags) ->
  tags = if _.isArray(tags) then tags.join(' ') else tags || ''
  _.map(_.compact(tags.split(/\s+/)), (tag) -> tag.replace(/[^a-z0-9-_]/gi, ''))

ItemSchema = new Schema(
  crosshead: String
  heading: String
  items: [ ItemSchema ]
  label: String
  repealed: Boolean
  text: String
  type: String
)

RevisionSchema = new Schema(
  administeredBy: String
  id: String
  in_amend: String
  instructing_office: String
  irdnumbering: String
  act_no:
    index: true
    type: Number
  act_type: String
  date_as_at:
    index: true
    type: Number
  date_assent:
    index: true
    type: Number
  date_first_valid:
    index: true
    type: Number
  file_path: String
  hard_copy_reprint: String
  prospective_consolidation: String
  stage: String
  year:
    index: true
    type: Number
  year_imprint:
    type: Number
  ids: [String]
  items: [ ItemSchema ]
  tags:
    default: []
    index: true
    set: (tags = []) ->
      tags = tags.split(/s+/g) unless _.isArray(tags)
      words = _.map(_.compact(tags.split(/s+/g)), (tag) ->
        tag.replace(/[^a-z0-9-_]/gi, '')
      )
      words.sort()
      _.uniq(words)
    type: [ String ]
)


ActSchema = new Schema(
  revisions: [ RevisionSchema ]
  status:
    index: true
    type: String
  title:
    index: true
    type: String
  updated:
    index: true
    type: Number
)
mongoose.model('Item', ItemSchema)
db.model('Item')
mongoose.model('Act', ActSchema)
module.exports.ActModel = db.model('Act')

