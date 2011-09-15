(function() {
  Ext.define('LH.model.ActDetail', {
    extend: 'Ext.data.Model',
    fields: ['deleted', 'inserted', 'title']
  });
  Ext.define('LH.model.Detail', {
    extend: 'Ext.data.Model',
    fields: ['key', 'acts', 'tags', 'title']
  });
  Ext.define('LH.model.Government', {
    extend: 'Ext.data.Model',
    fields: [
      '_id', 'description', {
        name: 'start',
        type: 'date',
        convert: function(v) {
          return new Date(v);
        }
      }, {
        name: 'end',
        type: 'date',
        convert: function(v) {
          return new Date(v);
        }
      }, 'inserted', 'deleted', 'theme'
    ]
  });
  Ext.define('LH.model.KeyWord', {
    extend: 'Ext.data.Model',
    fields: ['count', 'word']
  });
  Ext.define('LH.model.Revision', {
    extend: 'Ext.data.Model',
    fields: [
      '_id', 'title', {
        name: 'updated',
        type: 'date',
        convert: function(v) {
          return new Date(v);
        }
      }, 'html', {
        name: 'file_path',
        dataIndex: 'file_path',
        convert: function(v) {
          return "http://www.legislation.govt.nz/subscribe/" + (v.match(/.*\/raw\/(.+\/).*/, '$1')[1]);
        }
      }
    ]
  });
  Ext.define('LH.store.ActDetails', {
    extend: 'Ext.data.ArrayStore',
    model: 'LH.model.ActDetail'
  });
  Ext.define('LH.store.Details', {
    extend: 'Ext.data.Store',
    model: 'LH.model.Detail',
    proxy: {
      buildUrl: function(req) {
        return "/details/" + (this.record.get('_id')) + ".json";
      },
      reader: {
        type: 'json',
        root: 'detail',
        successProperty: 'success'
      },
      type: 'ajax',
      url: '/details/key.json'
    }
  });
  Ext.define('LH.store.Governments', {
    extend: 'Ext.data.Store',
    model: 'LH.model.Government',
    pageSize: 100,
    proxy: {
      reader: {
        type: 'json',
        root: 'governments',
        successProperty: 'success',
        totalProperty: 'totalCount'
      },
      type: 'ajax',
      url: '/governments.json'
    },
    sorters: [
      {
        property: 'start',
        direction: 'ASC'
      }
    ]
  });
  Ext.define('LH.store.KeyWords', {
    extend: 'Ext.data.Store',
    model: 'LH.model.KeyWord'
  });
  Ext.define('LH.store.Revisions', {
    buffered: true,
    extend: 'Ext.data.Store',
    model: 'LH.model.Revision',
    pageSize: 5,
    proxy: {
      reader: {
        type: 'json',
        root: 'revisions',
        successProperty: 'success',
        totalProperty: 'totalCount'
      },
      type: 'ajax',
      url: '/revisions/4e6e09d3ce6911bd1a000034.json'
    },
    remoteFilter: true,
    remoteSort: true
  });
  Ext.define('LH.view.government.Detail', {
    alias: 'widget.governmentdetail',
    border: false,
    extend: 'Ext.panel.Panel',
    flex: 1,
    initComponent: function() {
      this.callParent(arguments);
      return this.on('activate', function() {
        var _ref;
        return (_ref = this.findParentByType('governmenttab')) != null ? _ref.updateHash(this) : void 0;
      }, this);
    },
    layout: {
      align: 'stretch',
      type: 'border'
    },
    items: [
      {
        height: 36,
        region: 'north',
        xtype: 'governmentsummary'
      }, {
        flex: 3,
        region: 'west',
        xtype: 'teara'
      }, {
        flex: 4,
        region: 'center',
        xtype: 'snake'
      }, {
        flex: 2,
        region: 'east',
        xtype: 'keywords'
      }
    ],
    padding: '0 8'
  });
  Ext.chart.theme.Legislation = Ext.extend(Ext.chart.theme.Base, {
    constructor: function(config) {
      return Ext.chart.theme.Base.prototype.constructor.call(this, Ext.apply({
        colors: ['#ff0000', '#00ff00']
      }, config));
    }
  });
  Ext.define('LH.view.government.Graph', {
    alias: 'widget.governmentgraph',
    border: false,
    extend: 'Ext.chart.Chart',
    initComponent: function() {
      var government_store, total;
      government_store = Ext.data.StoreManager.get('Governments');
      this.store = new Ext.data.Store({
        fields: ['start', 'end', 'description', 'pm', 'total']
      });
      total = 0;
      government_store.on('load', function(s, records) {
        var last;
        Ext.getBody().unmask();
        _.each(records, function(record) {
          total += record.get('inserted');
          total -= record.get('deleted');
          return this.store.add({
            description: record.get('description'),
            inserted: record.get('inserted'),
            start: record.get('start'),
            end: record.get('end'),
            total: total
          });
        }, this);
        last = _.last(records);
        return this.store.add({
          description: last.get('description'),
          inserted: last.get('inserted'),
          pm: 'Wonky Donky',
          start: last.get('end'),
          end: last.get('end'),
          total: total
        });
      }, this);
      government_store.load();
      return this.callParent(arguments);
    },
    series: [
      {
        axis: 'left',
        highlight: true,
        tips: {
          renderer: function(record) {
            var end, start;
            start = Ext.Date.format(record.get('start'), 'j M Y');
            end = Ext.Date.format(record.get('end'), 'j M Y');
            return this.setTitle("" + (record.get('description')) + " " + start + " - " + end + ": Added " + (record.get('inserted')) + " lines");
          },
          width: 100,
          trackMouse: true
        },
        type: 'area',
        xField: 'start',
        yField: ['total']
      }
    ],
    label: 'Lines of legislation'
  });
  Ext.define('LH.view.government.Introduction', {
    alias: 'widget.introduction',
    border: false,
    cls: 'introduction',
    extend: 'Ext.panel.Panel',
    html: '<h1>Kia ora!</h1>\n<p>This site shows the <em>changes in New Zealand legislation</em> over time. It\'s easy to use!</p>\n<p>To get started, click on one of the governments above from the <em>last 158 years</em>. Then you can click on the acts of parliament changed by that government to <em>see what happened</em> -- or you can do your own searches.</p>\n<p>The data powering this site is provided by <a href="http://www.legislation.govt.nz">legislation.govt.nz</a> and is free of copyright.</p>\n<p>Have fun!</p>\n<p>P.S. All errors are mine (and there <em>are</em> errors!) not that of the <a href="http://www.legislation.govt.nz">legislation.govt.nz</a>.</p >',
    layout: 'fit',
    margins: 8
  });
  Ext.define('LH.view.government.KeyWords', {
    alias: 'widget.keywords',
    autoScroll: true,
    border: true,
    extend: 'Ext.panel.Panel',
    layout: 'auto',
    title: 'Keywords',
    fetch: function() {
      var detail_store;
      this.removeAll();
      detail_store = Ext.StoreManager.get('Details');
      this.setLoading(true);
      return detail_store.on('datachanged', function(s) {
        var records, tags, _ref;
        records = s.getRange();
        tags = ((_ref = records[0]) != null ? _ref.get('tags') : void 0) || [];
        _.each(tags, function(tag, i) {
          if (i < 50) {
            return this.add(new Ext.button.Button({
              margin: 5,
              text: tag.word
            }));
          }
        }, this);
        return this.setLoading(false);
      }, this, {
        single: true
      });
    },
    margins: 8
  });
  Ext.define('LH.view.government.Overview', {
    alias: 'widget.overview',
    border: false,
    extend: 'Ext.panel.Panel',
    padding: '0 100',
    setActive: function(num) {
      return this.get(1).layout.setActiveItem(num);
    },
    items: [
      {
        border: false,
        title: 'Total Legislation',
        xtype: 'panel',
        layout: 'fit',
        items: {
          xtype: 'governmentgraph'
        },
        height: 150
      }, {
        height: 36,
        xtype: 'governmentstrip'
      }, {
        flex: 1,
        xtype: 'governmenttab'
      }
    ],
    layout: {
      align: 'stretch',
      type: 'vbox'
    }
  });
  Ext.define('LH.view.government.Snake', {
    alias: 'widget.snake',
    autoScroll: true,
    border: true,
    columns: [
      {
        header: 'Act',
        dataIndex: 'title',
        menuDisabled: true,
        flex: 1
      }, {
        header: 'Words Added',
        dataIndex: 'inserted',
        menuDisabled: true
      }, {
        header: 'Words Removed',
        dataIndex: 'deleted',
        menuDisabled: true
      }
    ],
    extend: 'Ext.grid.Panel',
    fetch: function(record) {
      var detail_store;
      this.setLoading(true);
      detail_store = Ext.StoreManager.get('Details');
      detail_store.on('datachanged', function(store) {
        var acts, records, _ref;
        this.store.removeAll();
        records = store.getRange();
        acts = (_ref = records[0]) != null ? _ref.get('acts') : void 0;
        if (acts) {
          this.view.refresh();
          this.store.add(acts);
        }
        return this.setLoading(false);
      }, this);
      detail_store.proxy.record = record;
      return detail_store.load();
    },
    layout: 'fit',
    title: 'Acts Affected',
    margins: 8,
    store: 'ActDetails'
  });
  Ext.define('LH.view.government.Strip', {
    alias: 'widget.governmentstrip',
    border: false,
    cls: 'lh-govt-strip',
    extend: 'Ext.panel.Panel',
    initComponent: function() {
      this.callParent(arguments);
      this.addEvents('governmentselect');
      this.store = Ext.data.StoreManager.get('Governments');
      return this.store.on('load', function(store, records) {
        return _.each(records, function(record, i) {
          var govt;
          govt = new Ext.panel.Panel({
            cls: "lh-govt " + (record.get('theme')),
            flex: 1,
            html: "" + (i + 1),
            layout: 'fit',
            qtip: 'x',
            record: record
          });
          govt.on('render', function(c) {
            Ext.create('Ext.tip.ToolTip', {
              target: c.body,
              html: "" + (record.get('description'))
            });
            return c.body.on('click', function() {
              return this.react(c.record, c);
            }, this);
          }, this);
          return this.add(govt);
        }, this);
      }, this);
    },
    react: function(record) {
      _.each(this.items.getRange(), function(item) {
        if (record === item.record) {
          return item.addCls('active');
        } else {
          return item.removeCls('active');
        }
      });
      return this.fireEvent('governmentselect', record);
    },
    layout: {
      align: 'stretch',
      type: 'hbox'
    },
    padding: '0 8'
  });
  Ext.define('LH.view.government.Summary', {
    alias: 'widget.governmentsummary',
    border: false,
    cls: 'governmentsummary',
    extend: 'Ext.panel.Panel',
    items: [
      {
        border: false,
        flex: 1
      }, {
        border: false,
        flex: 1
      }, {
        border: false,
        flex: 3
      }
    ],
    layout: {
      align: 'stretch',
      type: 'hbox'
    },
    setText: function(record) {
      var end, start;
      start = Ext.Date.format(record.get('start'), 'j M Y');
      end = Ext.Date.format(record.get('end'), 'j M Y');
      this.items.get(0).update(record.get('description'));
      this.items.get(1).update("" + start + " - " + end);
      return this.items.get(2).update("Added " + (record.get('inserted')) + " lines of legislation");
    },
    padding: '0 8'
  });
  Ext.define('LH.view.government.Tab', {
    alias: 'widget.governmenttab',
    border: false,
    doTitleSearch: function(el) {
      this.layout.setActiveItem(2);
      return this.query('revisionlist')[0].doSearch("title:\"" + (el.lastSelected.get('title')) + "\"");
    },
    doSearch: function(el) {
      this.layout.setActiveItem(2);
      return this.query('revisionlist')[0].doSearch(el.text);
    },
    extend: 'Ext.panel.Panel',
    initComponent: function() {
      this.callParent(arguments);
      return this.on('afterrender', function() {
        var govt, store, tab, tabname, _ref;
        _ref = _.compact((Ext.History.getToken() || '').split('/')), tabname = _ref[0], govt = _ref[1];
        tab = this.query("#" + tabname)[0];
        if (tab) {
          this.layout.setActiveItem(tab);
        }
        if (tabname === 'govts' && govt) {
          store = Ext.StoreManager.get('Governments');
          return store.on('load', function() {
            var govtsummaries, keywords, list, record, snake, strip, teara;
            record = store.getAt(govt - 1);
            if (record) {
              strip = Ext.ComponentQuery.query('governmentstrip')[0];
              strip.react(record);
              list = Ext.ComponentQuery.query('revisionlist')[0];
              list.setUrl(record);
              teara = Ext.ComponentQuery.query('teara')[0];
              if (teara != null) {
                teara.fetch(record);
              }
              snake = Ext.ComponentQuery.query('snake')[0];
              if (snake != null) {
                snake.fetch(record);
              }
              keywords = Ext.ComponentQuery.query('keywords')[0];
              if (keywords != null) {
                keywords.fetch(record);
              }
              govtsummaries = Ext.ComponentQuery.query('governmentsummary');
              return _.each(govtsummaries, function(summary) {
                return summary.setText(record);
              });
            }
          }, this, {
            single: true
          });
        }
      });
    },
    updateHash: function(tab) {
      var oldToken, token;
      oldToken = Ext.History.getToken() || '';
      token = "/" + tab.id;
      if (oldToken.indexOf(token) !== 0) {
        return Ext.History.add(token);
      }
    },
    items: [
      {
        id: 'intro',
        xtype: 'introduction'
      }, {
        id: 'govts',
        xtype: 'governmentdetail'
      }, {
        id: 'search',
        xtype: 'revisioncontainer'
      }
    ],
    flex: 1,
    layout: 'card'
  });
  Ext.define('LH.view.government.TeAra', {
    alias: 'widget.teara',
    autoScroll: true,
    border: false,
    cls: 'teara',
    extend: 'Ext.panel.Panel',
    fetch: function(record) {
      var end, start, tokens;
      start = record.get('start');
      end = new Date(record.get('end'));
      this.setTitle("Te Ara search: years " + (Ext.Date.format(start, 'Y')) + " - " + (Ext.Date.format(end, 'Y')));
      tokens = [];
      while (start < end) {
        tokens.push(Ext.Date.format(start, 'Y'));
        start = Ext.Date.add(start, Ext.Date.YEAR, 1);
      }
      this.setLoading(true);
      return Ext.Ajax.request({
        failure: function() {
          this.update('Whoops. Something went wrong.');
          return this.setLoading(false);
        },
        url: "/teara/" + (tokens.join(' ')),
        scope: this,
        success: function(response) {
          this.update(response.responseText);
          return this.setLoading(false);
        }
      });
    },
    layout: 'fit',
    margins: 8,
    title: 'Te Ara Content'
  });
  Ext.define('LH.view.revision.Container', {
    alias: 'widget.revisioncontainer',
    border: false,
    extend: 'Ext.panel.Panel',
    initComponent: function() {
      this.items = [
        {
          height: 30,
          region: 'north',
          xtype: 'governmentsummary'
        }, {
          flex: 1,
          xtype: 'revisionlist'
        }
      ];
      return this.callParent(arguments);
    },
    layout: {
      align: 'stretch',
      type: 'vbox'
    }
  });
  Ext.define('LH.view.revision.List', {
    afterRender: function() {
      return this.textfield = this.down('textfield[name=filter]');
    },
    alias: 'widget.revisionlist',
    doSearch: function(s) {
      this.textfield.setValue(s);
      return this.onFilterChange();
    },
    extend: 'Ext.panel.Panel',
    initComponent: function() {
      this.tbar = [
        'Filter', {
          hideLabel: true,
          listeners: {
            change: {
              buffer: 500,
              fn: this.onFilterChange,
              scope: this
            }
          },
          name: 'filter',
          width: 600,
          xtype: 'textfield'
        }, '->', {
          cls: 'back',
          handler: function() {
            var govttab;
            govttab = Ext.ComponentQuery.query('governmenttab')[0];
            return govttab != null ? govttab.layout.setActiveItem(1) : void 0;
          },
          text: 'Back',
          xtype: 'button'
        }
      ];
      this.store = Ext.StoreManager.get('Revisions');
      this.dockedItems = [
        {
          xtype: 'pagingtoolbar',
          store: this.store,
          dock: 'bottom',
          displayInfo: true
        }
      ];
      this.panel = new Ext.panel.Panel({
        autoScroll: true,
        layout: 'auto',
        region: 'center'
      });
      this.items = this.panel;
      this.callParent(arguments);
      return this.store.on('datachanged', this.updateContent, this);
    },
    layout: {
      type: 'fit'
    },
    updateContent: function(s) {
      var records;
      records = s.getRange();
      this.panel.removeAll();
      return _.each(records, function(record) {
        return this.panel.add({
          html: record.get('html'),
          title: "" + (record.get('title')) + " @ " + (Ext.Date.format(record.get('updated'), 'j M Y')) + " <a href=\"" + (record.get('file_path')) + "\">source</a>",
          xtype: 'revisionview'
        });
      }, this);
    },
    onFilterChange: function() {
      this.panel.setLoading(true);
      this.store.on('datachanged', function() {
        return this.panel.setLoading(false);
      }, this);
      this.store.filters.clear();
      return this.store.filter('q', this.textfield.value);
    },
    setUrl: function(record) {
      return this.store.proxy.url = "/revisions/" + (record.get('_id')) + ".json";
    },
    title: false
  });
  Ext.define('LH.view.act.Revision', {
    alias: 'widget.revision',
    align: 'stretch',
    border: false,
    extend: 'Ext.panel.Panel',
    initComponent: function() {
      this.title = Ext.Date.format(new Date(this.revision.updated), 'j M Y');
      if (this.revision.date_terminated) {
        this.title += ' (Repealed)';
        this.status = 'Repealed';
      } else {
        this.status = 'In force';
      }
      this.callParent(arguments);
      this.add({
        autoScroll: true,
        border: false,
        html: this.revision.html,
        padding: 10,
        region: 'center',
        xtype: 'panel'
      });
      return this.add({
        border: false,
        fieldDefaults: {
          labelAlign: 'right'
        },
        items: [
          {
            fieldLabel: 'Path',
            listeners: {
              focus: function() {
                this.inputEl.dom.select();
                return false;
              }
            },
            value: this.revision.file_path,
            width: 600,
            xtype: 'textfield'
          }, {
            fieldLabel: 'Assented',
            value: this.revision.date_assent ? Ext.Date.format(new Date(this.revision.date_assent), 'j M Y') : '',
            xtype: 'displayfield'
          }, {
            fieldLabel: 'Date As At',
            value: this.revision.date_as_at ? Ext.Date.format(new Date(this.revision.date_as_at), 'j M Y') : '',
            xtype: 'displayfield'
          }, {
            fieldLabel: 'Date Updated',
            value: this.revision.udpated ? Ext.Date.format(new Date(this.revision.updated), 'j M Y') : '',
            xtype: 'displayfield'
          }, {
            fieldLabel: 'Status',
            value: this.status,
            xtype: 'displayfield'
          }, {
            fieldLabel: 'Year',
            value: this.revision.year,
            xtype: 'displayfield'
          }
        ],
        region: 'north',
        xtype: 'form'
      });
    },
    layout: 'border'
  });
  Ext.define('LH.view.act.Tab', {
    alias: 'widget.acttab',
    border: false,
    doSearch: function(el) {
      return this.layout.setActiveItem(3);
    },
    extend: 'Ext.panel.Panel',
    initComponent: function() {
      this.tbar = [
        {
          handler: function() {
            return this.layout.setActiveItem(0);
          },
          scope: this,
          text: 'Back',
          xtype: 'button'
        }, ' ', 'Lawhub'
      ];
      return this.callParent(arguments);
    },
    items: [
      {
        xtype: 'actlist'
      }
    ],
    layout: 'card'
  });
  Ext.define('LH.view.revision.View', {
    alias: 'widget.revisionview',
    border: false,
    cls: 'revisionview',
    extend: 'Ext.panel.Panel',
    layout: {
      align: 'stretch',
      type: 'auto'
    }
  });
  Ext.define('LH.controller.Governments', {
    extend: 'Ext.app.Controller',
    init: function() {
      return this.control({
        'governmentstrip': {
          governmentselect: function(record) {
            var govtsummaries, govttab, index, keywords, list, oldToken, snake, teara, token;
            oldToken = Ext.History.getToken();
            index = Ext.StoreManager.get('Governments').indexOf(record);
            token = "/govts/" + (index + 1);
            if (token !== oldToken) {
              Ext.History.add(token);
              list = Ext.ComponentQuery.query('revisionlist')[0];
              list.setUrl(record);
              govttab = Ext.ComponentQuery.query('governmenttab')[0];
              if (govttab != null) {
                govttab.layout.setActiveItem(1);
              }
              teara = Ext.ComponentQuery.query('teara')[0];
              if (teara != null) {
                teara.fetch(record);
              }
              snake = Ext.ComponentQuery.query('snake')[0];
              if (snake != null) {
                snake.fetch(record);
              }
              keywords = Ext.ComponentQuery.query('keywords')[0];
              if (keywords != null) {
                keywords.fetch(record);
              }
              govtsummaries = Ext.ComponentQuery.query('governmentsummary');
              return _.each(govtsummaries, function(summary) {
                return summary.setText(record);
              });
            }
          }
        },
        'keywords button': {
          'click': function(el) {
            var govttab;
            govttab = Ext.ComponentQuery.query('governmenttab')[0];
            return govttab != null ? govttab.doSearch(el) : void 0;
          }
        },
        'snake': {
          'select': function(el) {
            var govttab;
            govttab = Ext.ComponentQuery.query('governmenttab')[0];
            return govttab != null ? govttab.doTitleSearch(el) : void 0;
          }
        }
      });
    },
    models: ['ActDetail', 'Detail', 'KeyWord', 'Government'],
    stores: ['ActDetails', 'Details', 'KeyWords', 'Governments'],
    views: ['government.Overview', 'government.Detail', 'government.Strip', 'government.TeAra', 'government.Snake', 'government.KeyWords', 'government.Graph', 'government.Introduction', 'government.Tab', 'government.Summary']
  });
  Ext.define('LH.controller.Revisions', {
    extend: 'Ext.app.Controller',
    models: ['Revision'],
    stores: ['Revisions'],
    views: ['revision.List', 'revision.View', 'revision.Container']
  });
  Ext.application({
    controllers: ['Governments', 'Revisions'],
    views: ['overview'],
    launch: function() {
      Ext.History.init();
      return Ext.create('Ext.container.Viewport', {
        items: [
          {
            xtype: 'overview'
          }
        ],
        layout: {
          type: 'fit'
        }
      });
    },
    name: 'LH'
  });
}).call(this);
