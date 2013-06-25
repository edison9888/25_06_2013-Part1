/* 
 * Nirmal Kumar K S
 */

Ext.define('AFE.view.PieChartView',
{
    extend:'Ext.chart.Chart',
    id: 'pieChart',
    alias:'widget.pieChartView',
    //    width: 530,
    height: 250,
    width:'100%',
    //    flex:1,
    margin: '0 0 0 -30px',
    animate: true,
    store: 'TopAFEClassesStore',
    legend: {
        boxStrokeWidth: 0,
        position: 'float',
        x: 410,
        y: 50
    },
    theme: 'Base:gradients',
    series: [{
        type: 'pie',
        field: 'Budget',
        showInLegend: true,
        colorSet: ['#4D82BD','#C2504E','#9BBC55','#8065A2','#44ABC6'],
        tips: {
            trackMouse: true,
            width: 140,
            height: 28,
            renderer: function(storeItem, item) {
                //calculate and display percentage on hover
                var total = 0;
                var topAFEClassesStore=Ext.getStore('TopAFEClassesStore');
                topAFEClassesStore.each(function(rec) {
                    total += rec.get('Budget');
                });
                this.setTitle(storeItem.get('AFEClassName') + ': ' + Math.round(storeItem.get('Budget') / total * 100) + '%');
            }
        },
        label: {
            field: 'Budget',
            display: 'rotate',
            contrast: true,
            font: '13px Verdana'
        }
        
    }],
    listeners: {
//        beforerender: function(){
//            Ext.each(this.legend.items, function(item) {
//                item.un('mousedown', item.events.mousedown.listeners[0].fn);
//            });
//        },
        afterrender: function(chart, eOpts){
            var titleArray = new Array();
            var i=0;
            var topAFEClassesStore = chart.store;
            topAFEClassesStore.each(function(rec) {
                titleArray[i++]  = rec.get('AFEClassName');
            });
            chart.series.items[0].title = titleArray;
        }
    }
});

