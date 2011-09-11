server = require('../app')
_ = require('underscore')
qs = require('querystring')
request = require('request')
htmlparser = require('htmlparser')
select = require('soupselect').select

send_link = (links, res) ->
  if links.length is 0
    res.send('<div class="error">Oops! Something went wrong getting content from <a href="http://www.teara.govt.nz">Te Ara</a>. Hopefully it will sort itself out soon.')
  else
    index = Math.floor(Math.random() * links.length)
    link = links[index]
    links = links.splice(index, 1)
    href = link?.attribs.href.replace(/\d+$/, 'shortstory')
    url = "http://www.teara.govt.nz#{href}"
    console.log("url: #{url}")
    request(url, (err, response, body) ->
      if err
        res.send('<div class="error">Oops! Something went wrong getting content from <a href="http://www.teara.govt.nz">Te Ara</a>. Hopefully it will sort itself out soon.')
      else if response.status is 404
        send_link(links, res)
      else
        body_html = body.replace(/\r|\n/g, ' ').match(/(<body.+<\/body>)/m)[1]
        if body_html
          res.send(body_html.replace(/(href|src)="/g, '$1="http://www.teara.govt.nz'))
        else
          res.send('<div class="error">Oops! Something went wrong getting content from <a href="http://www.teara.govt.nz">Te Ara</a>. Hopefully it will sort itself out soon.')
    )

server.get('/teara/:search', (req, res) ->
  search = req.params.search or ''
  words = search.split(' ')
  params = qs.stringify(
    keys: words[Math.floor(Math.random() * words.length)]
    form_type: 'search'
    op: 'Search'
    form_id: 'teara_search_form'
  )
  request("http://www.teara.govt.nz/search?#{params}", (err, response, body) ->
    handler = new htmlparser.DefaultHandler (err, dom) ->
      if err
        res.send('<div class="error">Oops! Something went wrong getting content from <a href="http://www.teara.govt.nz">Te Ara</a>. Hopefully it will sort itself out soon.')
      else
        links = select(dom, '#results h4 a')
        links = links.slice(0, 5)
        send_link(links, res)

    parser = new htmlparser.Parser(handler)
    parser.parseComplete(body)
  )
)
