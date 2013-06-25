/*
*
* Merrin J
*/

//blue red yellow
var colors = ['#0000CC','#CC0000','#FFCC00'];
var baseColor = '#fff';

Ext.define('Ext.chart.theme.Fancy', {
    extend: 'Ext.chart.theme.Base',

    constructor: function(config) {
        this.callParent([Ext.apply({
            axis: {
                fill: baseColor,
                stroke: baseColor
            },
            axisLabelBottom: {
                fill: baseColor
            },
            colors: colors
        }, config)]);
    }
});

Ext.define('AFE.view.BarChartView',
{
    extend:'Ext.chart.Chart',
    alias:'widget.barChartView',
    xtype: 'chart',
    id:'barChart',
    theme:'Fancy',
    width: 300,
    height: 240,
    style: 'background:#fff',
    animate: true,
    store: 'TopBudgetedBarStore',

    axes: [{
        type: 'Numeric',
        position: 'bottom',
        fields: ['Budget'],
        minimum: 0 
        
    }, {
        type: 'Category',
        position: 'left',
        fields: ['AFENumber']
    }],
    series: [{
        type: 'bar',
        axis: 'bottom',
        groupGutter:0,
        //gutter:0,
        label: {
            display: 'outside',
            field:['Budget','Actual','FieldEstimate'],
            orientation: 'horizontal',
            renderer: Ext.util.Format.usMoney,
            color: '#FFFFFF'
        },
        xField: 'AFENumber',
        yField: ['Budget','Actual','FieldEstimate']
        
       /* renderer: function(sprite, storeItem, barAttr, i, store) {
            barAttr.fill = colors[i % colors.length];
            if(i == 0|| i == 1 || i==3 || i==4 ){
            barAttr.height =15;
            }
            else{
            barAttr.height =3;
            }
            return barAttr;
        }*/
    }]

               /*  listeners: {
                        afterrender: function(){
                            var arr = new Array();
                            var i=0;
                             store.each(function(rec) {
                             arr[i]=  rec.get('Budget');
                             alert(arr[i]);
                             i++;
                           });
                            var len = arr.length;
                            this.axes.items[0].maximum = arr[len-1] + 12000;
                         }
                 }*/
} );

