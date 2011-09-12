Detail = require('../models/detail').Detail
Government = require('../models/government').Government
_ = require('underscore')

mangleGovernment = (govt) ->
  Government.findById(govt._id)
    .run (err, govt) ->
      acts = []
      tags = []
      tag_bag = {}
      _.each(govt.acts, (act) ->
        prev = _.detect(acts, (el) -> el.title is act.title)
        if prev
          prev.inserted += act.inserted_wordcount
          prev.deleted += act.deleted_wordcount
        else
          acts.push(
            title: act.title
            inserted: act.inserted_wordcount
            deleted: act.inserted_wordcount
          )
        _.each(act.tags, (tag) ->
          prevTag = _.detect(tags, (el) -> el.word is tag.word)
          if prevTag
            prevTag.count += tag.count
            tag_bag[tag.word]++
          else
            tags.push(tag)
            tag_bag[tag.word] = 1
        )
      )
      debugger
      if tags.length > 10
        _.each(tags, (tag) ->
          if tag_bag[tag.word] > tags.length * 0.9
            tags = _.without(tags, tag)
        )
      new Detail(
        acts: _.sortBy(acts, (act) -> -act.inserted)
        key: govt._id
        tags: _.sortBy(tags, (tag) -> -tag.count)
        title: govt.description
      ).save (err, dtl) ->
        console.log("Saved detail #{dtl.title}.")

count = 0
module.exports.mine = ->
  Government.find()
    .fields(['_id'])
    .run (err, govts) ->
      _.each(govts, (govt) ->
        setTimeout ->
          mangleGovernment(govt)
        , count++ * 100
      )

