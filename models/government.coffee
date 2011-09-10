db = require('../db').db
mongoose = require('mongoose')
Schema = mongoose.Schema

GovernmentSchema = new Schema(
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
