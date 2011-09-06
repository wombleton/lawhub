mongoose = require('mongoose')
db = require('./db').db
fs = require('fs')
path = require('path')
sax = require('./sax-js')
file = require('file')
_ = require('underscore')
billParser = require('./bill-parser')
Bill = billParser.Bill
Schema = mongoose.Schema

BillSchema = new Schema(
  attributes:
    default: {}
  author:
    default: ''
    type: String
  billType:
    default: ''
    type: String
  footNotes:
    default: []
  notes:
    default: []
  provisions:
    default: []
  title:
    default: ''
)

mongoose.model('Bill', BillSchema)
BillModel = db.model('Bill')

module.exports.parse = (filename) ->
  f = fs.readFileSync(filename, 'utf8')
  parser = sax.parser()

  bill = undefined

  parser.onopentag = (node) ->
    if node.name is 'BILL'
      bill = new Bill()
    if bill
      tag = node.name.toLowerCase()
      bill.stack.push(tag)
      bill.openTag(tag, node.attributes)

  parser.onclosetag = (tagname) ->
    bill.stack.pop()
    bill.closeTag(tagname.toLowerCase())

  parser.ontext = (t) ->
    bill?.acceptText(t)

  parser.onend = ->
    bill.cleanup()

  parser.write(f)
  parser.close()

  am = new BillModel(bill)
  am.save((err) ->
    console.log("ERROR: #{err}") if err
  )
  return
