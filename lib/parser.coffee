file = require('file')
path = require('path')
act = require('./act')
_ = require('underscore')

XML_FILE = /\.xml$/
ACT_FILE = /\/raw\/act\//

actsParsed = 0
in_progress = {}
waiting = []

parseFile = ->
  if waiting.length > 0 and _.keys(in_progress).length < 5
    file = waiting.shift()
    in_progress[file] = true

    console.log("Parsing #{file}...")
    act.parse(file, ->
      delete in_progress[file]
      console.log("Successfully parsed #{file} (#{++actsParsed} successful; #{waiting.length} waiting)")
      parseFile()
    )

parse = ->
  file.walk(path.join(__dirname, '..', '/raw/act'), (e, dirPath, dirs, files) ->
    _.each(files, (file) ->
      if XML_FILE.test(file) and ACT_FILE.test(file)
        waiting.push(file)
        if _.keys(in_progress).length < 5
          parseFile()
    )
  )

module.exports.parse = parse
