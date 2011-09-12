db = require('../db').db
mongoose = require('mongoose')
Schema = mongoose.Schema
TagSchema = require('./government').TagSchema

ActDetailSchema = new Schema(
  title: String
  inserted:
    index: true
    type: Number
  deleted:
    type: Number
)

DetailSchema = new Schema(
  acts: [ ActDetailSchema ]
  key: String
  tags: [ TagSchema ]
  title: String
)

mongoose.model('Detail', DetailSchema)
module.exports.Detail = db.model('Detail')
