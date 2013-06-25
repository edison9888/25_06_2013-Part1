/* 
 *Nirmal Kumar K S
 */

var customChartColors = ['blue', 'red'];

Ext.chart.theme.MyCustomChartTheme = Ext.extend(Ext.chart.theme.Base,  {
    constructor: function(config) {
        Ext.chart.theme.Base.prototype.constructor.call(this, Ext.apply({
            colors: customChartColors
        }, config));
    }
});

Ext.define('AFE.view.BurnDownChartView',
{
    extend:'Ext.chart.Chart',
    alias:'widget.burnDownChartView',
    id: 'burnDownChart',
    //    width: 530,
    //    height: 310,
    width:'100%',
    flex:1,
    hidden: false,
    xtype: 'chart',
    style: 'background:#fff',
    animate: true,
    theme: 'MyCustomChartTheme',
    legend: {
        boxStrokeWidth: 0,
        position: 'top'
    },
    store: 'AFEBurnDownStore',
    axes: [{
        type: 'Numeric',
        position: 'left',
        fields: ['Actual','CumulativeActual','FieldEstimate','CumulativeFieldEstimate','Budget'],
        minimum: 0,
        maximum: 100000000,
        majorTickSteps: 9,
        label: {
            renderer: function(v) {
                return String(v).replace(/(.)00000$/, '.$1M');
            }
        },
        grid: true
    }, {
        type: 'Category',
        position: 'bottom',
        fields: ['DateAsStr'],
        label: {
            renderer: Ext.util.Format.dateRenderer('M')
        }
    }],
    series: [{
        type: 'line',
        axis: 'left',
        title: 'AFE Estimate',
        xField: 'DateAsStr',
        yField: 'Budget',
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
    },{
        type: 'column',
        axis: 'left',
        title: ['Actual','Accruals'],
        xField: 'DateAsStr',
        yField: ['Actual','FieldEstimate'],
        stacked: true,
        gutter: 80,
        //        style:	{
        //            fill: 'blue'
        //        },
        //        renderer: function(sprite, record, attr, index, store) {
        //            return Ext.apply(attr, {
        //                fill: 'blue'
        //            });
        //        },
        highlight: {
            stroke: 'black',
            'stroke-width': 3
        },
        tips: {
            trackMouse: true,
            width: 140,
            height: 28,
            renderer: function(storeItem, item) {
                this.setTitle('$' + item.value[1]);
            }
        }
    }, {
        type: 'line',
        axis: 'left',
        title: 'Cumulative',
        xField: 'DateAsStr',
        yField: 'CumulativeFieldEstimate',
        showMarkers: false,
        style: {
            stroke: '#991A35',
            'stroke-width': 3
        },
        highlight: {
            size: 7,
            radius: 7
        }
    }]

})

