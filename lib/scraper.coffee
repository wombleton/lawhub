DOMAIN = 'http://legislation.govt.nz'
BASE_URL = "#{DOMAIN}/subscribe"
XML_FILE = /\.xml$/
SVG_FILE = /\.svg$/
DIRECTORY_REGEX = /class="directory">\s*.+?href="([^"]+)"/gym
FILE_REGEX = /class="file">\s*.+?href="([^"]+)"/gym

request = require('request')
_ = require('underscore')
fs = require('fs')
path = require('path')
file = require('file')

writeFile = (filePath, body) ->
  dirPath = path.dirname(filePath)
  file.mkdirs(dirPath, '755', (err) ->
    f = fs.openSync("#{filePath}", 'w+')
    if err
      console.log("Could not create file: #{err.message}")
    else
      fs.writeSync(f, body)
      fs.closeSync(f)
      console.log("Successfully written #{filePath}")
  )

directoryUrls = [BASE_URL]

readFile = (fileUrl) ->
  filePath = fileUrl.replace(DOMAIN, '').replace(/^\/subscribe, 'raw').toLowerCase()
  path.exists(filePath, (exists) ->
    if exists
      console.log("Skipping #{filePath} as it already exists.")
    else
      console.log("Downloading file #{filePath}...")
      request(
        url: fileUrl
        (error, response, body) ->
          writeFile(filePath, body)
      )
  )

nextDirectory = ->
  if directoryUrls.length == 0
    nextFile()
  else
    url = directoryUrls.shift()
    readPage(url)

readPage = (uri) ->
  # console.log("Reading #{uri}...")
  request(
    uri: uri
    (error, response, body) ->
      if error && response.statusCode isnt 200
        console.log("Error requesting #{uri}")
      while f = FILE_REGEX.exec(body)?[1]
        readFile("#{DOMAIN}#{f.toLowerCase()}") if XML_FILE.test(f) or SVG_FILE.test(f)

      while directory = DIRECTORY_REGEX.exec(body)?[1]
        directoryUrls.push("#{DOMAIN}#{directory.toLowerCase()}")
      readDirectories()
  )

readDirectories = ->
  while directoryUrls.length > 0
    readPage(directoryUrls.shift())

readDirectories()
