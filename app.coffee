express = require('express')
server = express.createServer()
cs = require('coffee-script')

server.configure ->
  server.use express.logger()
  server.use express.bodyParser()
  server.use express.methodOverride()
  server.use express.static("#{__dirname}/static")
  server.use express.cookieParser()

server.configure 'production', ->
  process.env.server = 'PRODUCTION'
  server.listen(80)

server.configure 'development', ->
  process.env.server = 'DEVELOPMENT'
  server.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )
  server.listen 3000

server.configure 'test', ->
  process.env.server = 'TEST'
  module.exports.server = server;

server.set('views', "#{__dirname}/views")
server.set('view engine', 'jade')

module.exports.server = server

require './models/act'
require './controllers/acts'
