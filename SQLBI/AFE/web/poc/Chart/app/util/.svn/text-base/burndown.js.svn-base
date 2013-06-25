var customChartColors = ['blue'];
 
    Ext.chart.theme.MyCustomChartTheme = Ext.extend(Ext.chart.theme.Base,  {
      constructor: function(config) {
        Ext.chart.theme.Base.prototype.constructor.call(this, Ext.apply({
          colors: customChartColors
        }, config));
      }
    });
	
	
	Ext.define('afeStore', {
		extend: 'Ext.data.Model',
		fields: [
		   {name: 'month', type: 'string'},
		   {name: 'data1', type: 'int'},
		   {name: 'data2', type: 'int'},
		   {name: 'data3', type: 'int'}
		]
	});
	
	
	var afe = Ext.create('Ext.data.Store', {
		model: 'afeStore',
		proxy: {
			type: 'ajax', 
			url: './resources/json/burndown.json',
			reader: {
				type: 'json',
				root: 'afedata'
			}
		},
		autoLoad: true
	});
	

Ext.onReady(function () {

    var chart = Ext.create('Ext.chart.Chart', {
			renderTo: Ext.getBody(),
            id: 'chartCmp',
			width: 800,
			height: 600,
			hidden: false,
            xtype: 'chart',
            style: 'background:#fff',
            animate: true,
			legend: {
				boxStrokeWidth: 0,
				position: 'top'
			},
            store: afe,
            axes: [{
                type: 'Numeric',
                position: 'left',
                fields: ['data1','data2','data3'],
				minimum: 0,
                maximum: 100000000,
				majorTickSteps: 9,
                label: {
                    renderer: Ext.util.Format.numberRenderer('0,0')
                },
                grid: true
            }, {
                type: 'Category',
                position: 'bottom',
                fields: ['month'],
				label: {
					renderer: function(month) {
						return month.substr(0, 3) + ' 12';
					}
				}
            }],
            series: [{
                type: 'column',
                axis: 'left',
				title: 'Field Estimate',
				showInLegend: true,
                xField: 'month',
                yField: 'data1',
				style:	{
					fill: 'blue'
				},
				renderer: function(sprite, record, attr, index, store) {
					return Ext.apply(attr, {
						fill: 'blue'
					});
				},
				highlight: {
					stroke: 'black',
					'stroke-width': 3
				},
				tips: {
                  trackMouse: true,
                  width: 140,
                  height: 28,
                  renderer: function(storeItem, item) {
                    this.setTitle(storeItem.get('month') + ':  $' + storeItem.get('data1'));
                  }
                }
            }, {
                type: 'line',
                axis: 'left',
				title: 'Cumulative',
				showInLegend: true,
                xField: 'month',
                yField: 'data2',
				style: {
					stroke: 'red',
					'stroke-width': 3
				},
				highlight: {
                    size: 7,
                    radius: 7
                }
            }, {
                type: 'line',
                axis: 'left',
				title: 'Budget',
				showInLegend: true,
                xField: 'month',
                yField: 'data3',
				showMarkers: false,
				style: {
					fill: 'green',
					stroke: 'green',
					'stroke-width': 3,
					'stroke-dasharray': 14
				},
				highlight: {
                    size: 7,
                    radius: 7
                }
            }]
        });
});
