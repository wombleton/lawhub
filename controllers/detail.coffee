
server.get('/details/:key.json', (req, res) ->
  id = req.params.key
  Government.findById(id,
    (err, govt) ->
      acts = _.reduce(govt.acts, (memo, act) ->
        prev = _.detect(memo, (el) -> el.title is act.title)
        if prev
          prev.inserted_wordcount += act.inserted_wordcount
          prev.deleted_wordcount += act.deleted_wordcount
        else
          memo.push(
            title: act.title
            deleted_wordcount: act.deleted_wordcount
            inserted_wordcount: act.inserted_wordcount
          )
        memo
      , [])

      res.charset = 'utf-8'
      res.contentType('application/json')
      res.send(
        act_details: []
        title: govt.title
        success: true
      )
  )
)
