Government = require('../models/government').Government
Revision = require('../models/revision').Revision
_ = require('underscore')

governments = [
  {
    description: 'No Formal Government'
    start: new Date('1853-07-04').getTime()
    end: new Date('1855-10-27').getTime()
  }
  {
    description: 'No Formal Government'
    start: new Date('1855-10-28').getTime()
    end: new Date('1860-12-11').getTime()
  }
  {
    description: 'No Formal Government'
    start: new Date('1860-12-12').getTime()
    end: new Date('1866-02-11').getTime()
  }
  {
    description: 'No Formal Government'
    start: new Date('1866-02-12').getTime()
    end: new Date('1871-01-13').getTime()
  }
  {
    description: 'No Formal Government'
    start: new Date('1871-01-14').getTime()
    end: new Date('1875-12-29').getTime()
  }
  {
    description: 'No Formal Government'
    start: new Date('1875-12-30').getTime()
    end: new Date('1879-08-27').getTime()
  }
  {
    description: 'No Formal Government'
    start: new Date('1879-08-28').getTime()
    end: new Date('1881-12-08').getTime()
  }
  {
    description: 'No Formal Government'
    start: new Date('1881-12-09').getTime()
    end: new Date('1884-06-21').getTime()
  }
  {
    description: 'No Formal Government'
    start: new Date('1884-06-22').getTime()
    end: new Date('1887-09-25').getTime()
  }
  {
    description: 'No Formal Government'
    start: new Date('1887-09-26').getTime()
    end: new Date('1890-12-04').getTime()
  }
  {
    description: 'First Liberal'
    start: new Date('1890-12-05').getTime()
    end: new Date('1893-11-27').getTime()
  }
  {
    description: 'First Liberal'
    start: new Date('1893-11-28').getTime()
    end: new Date('1896-12-03').getTime()
  }
  {
    description: 'First Liberal'
    start: new Date('1896-12-04').getTime()
    end: new Date('1899-12-05').getTime()
  }
  {
    description: 'First Liberal'
    start: new Date('1899-12-06').getTime()
    end: new Date('1902-11-24').getTime()
  }
  {
    description: 'First Liberal'
    start: new Date('1902-11-25').getTime()
    end: new Date('1905-12-05').getTime()
  }
  {
    description: 'First Liberal'
    start: new Date('1905-12-06').getTime()
    end: new Date('1908-11-16').getTime()
  }
  {
    description: 'First Liberal'
    start: new Date('1908-11-17').getTime()
    end: new Date('1911-12-06').getTime()
  }
  {
    description: 'Reform'
    start: new Date('1911-12-07').getTime()
    end: new Date('1914-12-09').getTime()
  }
  {
    description: 'Reform'
    start: new Date('1914-12-10').getTime()
    end: new Date('1919-12-16').getTime()
  }
  {
    description: 'Reform'
    start: new Date('1919-12-17').getTime()
    end: new Date('1922-12-06').getTime()
  }
  {
    description: 'Reform'
    start: new Date('1922-12-07').getTime()
    end: new Date('1925-11-03').getTime()
  }
  {
    description: 'Reform'
    start: new Date('1925-11-04').getTime()
    end: new Date('1928-11-13').getTime()
  }
  {
    description: 'United'
    start: new Date('1928-11-13').getTime()
    end: new Date('1931-12-01').getTime()
  }
  {
    description: 'Liberal-Reform coalition'
    start: new Date('1931-12-02').getTime()
    end: new Date('1935-11-26').getTime()
  }
  {
    description: 'First Labour'
    start: new Date('1935-11-27').getTime()
    end: new Date('1938-10-14').getTime()
  }
  {
    description: 'First Labour'
    start: new Date('1938-10-15').getTime()
    end: new Date('1943-09-24').getTime()
  }
  {
    description: 'First Labour'
    start: new Date('1943-09-25').getTime()
    end: new Date('1946-11-26').getTime()
  }
  {
    description: 'First Labour'
    start: new Date('1946-11-27').getTime()
    end: new Date('1949-11-29').getTime()
  }
  {
    description: 'First National'
    start: new Date('1949-11-30').getTime()
    end: new Date('1951-08-31').getTime()
  }
  {
    description: 'First National'
    start: new Date('1951-09-01').getTime()
    end: new Date('1954-11-12').getTime()
  }
  {
    description: 'First National'
    start: new Date('1954-11-13').getTime()
    end: new Date('1957-11-29').getTime()
  }
  {
    description: 'Second Labour'
    start: new Date('1957-11-30').getTime()
    end: new Date('1960-11-25').getTime()
  }
  {
    description: 'Second National'
    start: new Date('1960-11-26').getTime()
    end: new Date('1963-11-29').getTime()
  }
  {
    description: 'Second National'
    start: new Date('1963-11-30').getTime()
    end: new Date('1966-11-25').getTime()
  }
  {
    description: 'Second National'
    start: new Date('1966-11-26').getTime()
    end: new Date('1969-11-28').getTime()
  }
  {
    description: 'Second National'
    start: new Date('1969-11-29').getTime()
    end: new Date('1972-11-24').getTime()
  }
  {
    description: 'Third Labour'
    start: new Date('1972-11-25').getTime()
    end: new Date('1975-11-28').getTime()
  }
  {
    description: 'Third National'
    start: new Date('1975-11-29').getTime()
    end: new Date('1978-11-24').getTime()
  }
  {
    description: 'Third National'
    start: new Date('1978-11-25').getTime()
    end: new Date('1981-11-27').getTime()
  }
  {
    description: 'Third National'
    start: new Date('1981-11-28').getTime()
    end: new Date('1984-07-13').getTime()
  }
  {
    description: 'Fourth Labour'
    start: new Date('1984-07-14').getTime()
    end: new Date('1987-08-14').getTime()
  }
  {
    description: 'Fourth Labour'
    start: new Date('1987-08-15').getTime()
    end: new Date('1990-10-26').getTime()
  }
  {
    description: 'Fourth National'
    start: new Date('1990-10-27').getTime()
    end: new Date('1993-11-05').getTime()
  }
  {
    description: 'Fourth National'
    start: new Date('1993-11-06').getTime()
    end: new Date('1996-10-11').getTime()
  }
  {
    description: 'Fourth National'
    start: new Date('1996-10-12').getTime()
    end: new Date('1999-11-26').getTime()
  }
  {
    description: 'Fifth Labour'
    start: new Date('1999-11-27').getTime()
    end: new Date('2002-07-26').getTime()
  }
  {
    description: 'Fifth Labour'
    start: new Date('2002-07-27').getTime()
    end: new Date('2005-09-16').getTime()
  }
  {
    description: 'Fifth Labour'
    start: new Date('2005-09-17').getTime()
    end: new Date('2008-11-07').getTime()
  }
  {
    description: 'Fifth National'
    start: new Date('2008-11-08').getTime()
    end: new Date('2011-11-25').getTime()
  }
]

module.exports.extract = ->
  Government.find({}, (err, govts) ->
    if govts.length is 0
      _.each(governments, (govt) ->
        govt = _.extend(govt,
          inserted: 0
          deleted: 0
        )
        government = new Government(govt)
        government.save (err, g) ->
          if err
            debugger
          else
            Revision.find({
              updated:
                $lt: g.end
                $gt: g.start
            }, (err, docs) ->
              if err
                debugger
              else
                _.each(docs, (doc) ->
                  _.each(doc.delta, (delt) ->
                    Government.update(
                      start: govt.start,
                      {
                        $inc:
                          deleted: delt.deleted.length
                          inserted: delt.inserted.length
                      },
                      {
                        multi: true
                      },
                      (err, updated) ->
                        console.log("Updated #{govt.description} with #{doc.title}. Had #{govt.inserted}/#{govt.deleted} inserted/deleted.")
                        if err
                          debugger
                    )
                  )
                )
            )
      )
  )
