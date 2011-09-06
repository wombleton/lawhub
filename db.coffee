Mongoose = require('mongoose')

if process.env.server == 'TEST'
  db = Mongoose.connect('mongodb://localhost/testlawhub')
else
  db = Mongoose.connect('mongodb://localhost/lawhub')

module.exports.db = db
