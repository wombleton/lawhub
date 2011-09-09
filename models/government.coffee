db = require('../db').db
mongoose = require('mongoose')
Schema = mongoose.Schema

GovernmentSchema = new Schema(
  description: String
  start:
    index: true
    type: Date
  end:
    index: true
    type: Date
  inserted: [ String ]
  deleted: [ String ]
)
