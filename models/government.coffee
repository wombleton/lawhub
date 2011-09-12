db = require('../db').db
mongoose = require('mongoose')
Schema = mongoose.Schema

TagSchema = new Schema(
  norm: String
  word: String
  count:
    index: true
    type: Number
)

ActSummarySchema = new Schema(
  title: String
  tags: [ TagSchema ]
  inserted_wordcount:
    index: true
    type: Number
  deleted_wordcount:
    type: Number
)

GovernmentSchema = new Schema(
  acts: [ ActSummarySchema ]
  description: String
  start:
    index: true
    type: Number
  end:
    type: Number
  inserted:
    default: 0
    type: Number
  deleted:
    default: 0
    type: Number
)

mongoose.model('Government', GovernmentSchema)
module.exports.Government = db.model('Government')
module.exports.TagSchema = TagSchema
