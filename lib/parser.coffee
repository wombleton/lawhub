file = require('file')
path = require('path')
act = require('./act')
_ = require('underscore')

XML_FILE = /\.xml$/
ACT_FILE = /\/raw\/act\//

module.exports.parse = ->
  actsParsed = billsParsed = 0

  file.walk(path.join(__dirname, '..', '/raw/act/public/1994/0166/111.0'), (e, dirPath, dirs, files) ->
    #file.walk(path.join(__dirname, '..', '/raw/act'), (e, dirPath, dirs, files) ->
    _.each(files, (file) ->
      if XML_FILE.test(file)
        console.log("Parsing #{file}...")
        if ACT_FILE.test(dirPath)
          act.parse(file)
          console.log("Acts parsed: #{++actsParsed}")
    )
  )
