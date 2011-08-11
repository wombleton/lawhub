(function() {
  var BASE_URL, DIRECTORY_REGEX, DOMAIN, FILE_REGEX, SVG_FILE, XML_FILE, directoryUrls, file, fs, nextDirectory, path, readDirectories, readFile, readPage, request, writeFile, _;
  DOMAIN = 'http://legislation.govt.nz';
  BASE_URL = "" + DOMAIN + "/subscribe";
  XML_FILE = /\.xml$/;
  SVG_FILE = /\.svg$/;
  DIRECTORY_REGEX = /class="directory">\s*.+?href="([^"]+)"/gym;
  FILE_REGEX = /class="file">\s*.+?href="([^"]+)"/gym;
  request = require('request');
  _ = require('underscore');
  fs = require('fs');
  path = require('path');
  file = require('file');
  writeFile = function(filePath, body) {
    var dirPath;
    dirPath = path.dirname(filePath);
    return file.mkdirs(dirPath, '755', function(err) {
      var f;
      f = fs.openSync("" + filePath, 'w+');
      if (err) {
        return console.log("Could not create file: " + err.message);
      } else {
        fs.writeSync(f, body);
        fs.closeSync(f);
        return console.log("Successfully written " + filePath);
      }
    });
  };
  directoryUrls = [BASE_URL];
  readFile = function(fileUrl) {
    var filePath;
    filePath = fileUrl.replace(DOMAIN, '').replace(/^\//, '').toLowerCase();
    return path.exists(filePath, function(exists) {
      if (exists) {
        return console.log("Skipping " + filePath + " as it already exists.");
      } else {
        console.log("Downloading file " + filePath + "...");
        return request({
          url: fileUrl
        }, function(error, response, body) {
          return writeFile(filePath, body);
        });
      }
    });
  };
  nextDirectory = function() {
    var url;
    if (directoryUrls.length === 0) {
      return nextFile();
    } else {
      url = directoryUrls.shift();
      return readPage(url);
    }
  };
  readPage = function(uri) {
    return request({
      uri: uri
    }, function(error, response, body) {
      var directory, f, _ref, _ref2;
      if (error && response.statusCode !== 200) {
        console.log("Error requesting " + uri);
      }
      while (f = (_ref = FILE_REGEX.exec(body)) != null ? _ref[1] : void 0) {
        if (XML_FILE.test(f) || SVG_FILE.test(f)) {
          readFile("" + DOMAIN + (f.toLowerCase()));
        }
      }
      while (directory = (_ref2 = DIRECTORY_REGEX.exec(body)) != null ? _ref2[1] : void 0) {
        directoryUrls.push("" + DOMAIN + (directory.toLowerCase()));
      }
      return readDirectories();
    });
  };
  readDirectories = function() {
    var _results;
    _results = [];
    while (directoryUrls.length > 0) {
      _results.push(readPage(directoryUrls.shift()));
    }
    return _results;
  };
  readDirectories();
}).call(this);
