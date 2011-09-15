Ext.define('LH.view.government.Introduction',
  alias: 'widget.introduction'
  border: false
  cls: 'introduction'
  extend: 'Ext.panel.Panel'
  html: '''
    <h1>Kia ora!</h1>
    <p>This site shows the <em>changes in New Zealand legislation</em> over time. It's easy to use!</p>
    <p>To get started, click on one of the governments above from the <em>last 158 years</em>. Then you can click on the acts of parliament changed by that government to <em>see what happened</em> -- or you can do your own searches.</p>
    <p>The data powering this site is provided by <a href="http://www.legislation.govt.nz">legislation.govt.nz</a> and is free of copyright.</p>
    <p>Have fun!</p>
    <p>P.S. All errors are mine (and there <em>are</em> errors!) not that of the <a href="http://www.legislation.govt.nz">legislation.govt.nz</a>.</p >
  '''
  layout: 'fit'
  margins: 8
)
