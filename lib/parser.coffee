file = require('file')
path = require('path')
act = require('./act')
_ = require('underscore')

XML_FILE = /\.xml$/
ACT_FILE = /\/raw\/act\//

actsParsed = 0
waiting = []

parseFile = ->
  if waiting?.length > 0
    [dirPath, file] = waiting[0]

    if XML_FILE.test(file)
      if ACT_FILE.test(dirPath)
        console.log("Parsing #{file}...")
        act.parse(file, ->
          console.log("Successfully parsed #{file} (#{++actsParsed} successful)")
          parseFile()
        )

parse = ->
  file.walk(path.join(__dirname, '..', '/raw/act'), (e, dirPath, dirs, files) ->
    _.each(files, (file) ->
      waiting.push([dirPath, file])
      if waiting.length is 1
        parseFile()
    )
  )

module.exports.parse = parse
