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

server.configure 'development', ->
  process.env.server = 'DEVELOPMENT'
  server.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

server.configure 'test', ->
  process.env.server = 'TEST'
  module.exports.server = server;

server.set('views', "#{__dirname}/views")
server.set('view engine', 'jade')

module.exports = server

require './models/revision'
require './controllers/revisions'
require './models/government'
require './controllers/governments'
require './controllers/teara'
require './controllers/details'
require './controllers/deltas'
