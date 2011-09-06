Mongoose = require('mongoose')

db = Mongoose.connect('mongodb://localhost/lawhub')

module.exports.db = db

