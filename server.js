cs = require('coffee-script')
cluster = require('cluster')

cluster('app')
  .use(cluster.repl('/var/run/cluster.sock'))
  .listen(80)
//require('./app').listen(3000)
