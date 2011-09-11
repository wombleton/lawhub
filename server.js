cs = require('coffee-script')
cluster = require('cluster')

cluster('app').listen(3000)
