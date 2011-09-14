Ext.define('LH.view.government.Introduction',
  alias: 'widget.introduction'
  border: false
  cls: 'introduction'
  extend: 'Ext.panel.Panel'
  html: '''
    <h1>Kia ora!</h1>
    <p>This site shows the changes in New Zealand legislation over time. It's easy to use.</p>
    <p>To get started, click on one of the governments above from the last 150 years. Then you can click on the acts of parliament changed by that government to see what happened -- or you can do your own searches.</p>
    <p>The data powering this site was provided by <a href="http://www.legislation.govt.nz">legislation.govt.nz</a> and is licensed under Crown Copyright.</p>
    <p>Have fun!</p>
  '''
  layout: 'fit'
  margins: 8
)
