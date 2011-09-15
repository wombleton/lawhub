fs     = require 'fs'
{exec} = require 'child_process'

files = [
  'app/model/ActDetail'
  'app/model/Detail'
  'app/model/Government'
  'app/model/KeyWord'
  'app/model/Revision'
  'app/store/ActDetails'
  'app/store/Details'
  'app/store/Governments'
  'app/store/KeyWords'
  'app/store/Revisions'
  'app/view/government/Detail'
  'app/view/government/Graph'
  'app/view/government/Introduction'
  'app/view/government/KeyWords'
  'app/view/government/Overview'
  'app/view/government/Snake'
  'app/view/government/Strip'
  'app/view/government/Summary'
  'app/view/government/Tab'
  'app/view/government/TeAra'
  'app/view/revision/Container'
  'app/view/revision/List'
  'app/view/revision/Revision'
  'app/view/revision/Tab'
  'app/view/revision/View'
  'app/controller/Governments'
  'app/controller/Revisions'
  'app'
]

task 'build', 'Build single application file from source files', ->
  appContents = new Array remaining = files.length
  for file, index in files then do (file, index) ->
    fs.readFile "static/js/#{file}.coffee", 'utf8', (err, fileContents) ->
      throw err if err
      appContents[index] = fileContents
      process() if --remaining is 0
  process = ->
    fs.writeFile 'static/js/lawhub.coffee', appContents.join('\n\n'), 'utf8', (err) ->
      throw err if err
      exec 'coffee --compile static/js/lawhub.coffee', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
        fs.unlink 'static/js/lawhub.coffee', (err) ->
          throw err if err
          console.log 'Done.'

task 'minify', 'Minify the resulting application file after build', ->
  exec 'uglifyjs -o static/js/lawhub.min.js static/js/lawhub.js', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
