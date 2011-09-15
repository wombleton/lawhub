cs = require('coffee-script')
cluster = require('cluster')

cluster('app').listen(80)
//require('./app').listen(3000)
