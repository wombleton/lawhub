db = require('../db').db
mongoose = require('mongoose')
Schema = mongoose.Schema
dateformat = require('dateformat')
md = require('node-markdown').Markdown
_ = require('underscore')

DiffSchema = new Schema(
  preamble: [ String ]
  postscript: [ String ]
  deleted:
    index: true
    type: [ String ]
  inserted:
    index: true
    type: [ String ]
)

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
  act_no:
    index: true
    type: String
  act_type: String
  date_as_at:
    type: Number
  date_assent:
    type: Number
  date_first_valid:
    type: Number
  date_terminated:
    type: Number
  delta: [ DiffSchema ]
  file_path: String
  hard_copy_reprint: String
  id: String
  ids: [String]
  in_amend: String
  instructing_office: String
  irdnumbering: String
  items: [ ItemSchema ]
  markdown: String
  prospective_consolidation: String
  stage: String
  title: String
  year:
    index: true
    type: Number
  year_imprint:
    type: Number
  updated:
    index: true
    type: Number
)


mongoose.model('Revision', RevisionSchema)
module.exports.Revision= db.model('Revision')

