Ext.require('Ext.chart.*');
Ext.require(['Ext.Window', 'Ext.fx.target.Sprite', 'Ext.layout.container.Fit', 'Ext.window.MessageBox']);

Ext.onReady(function () {

 window.generateData = function(n, floor){
        var data = [],
            p = (Math.random() *  11) + 1,
            i;
            
        floor = (!floor && floor !== 0)? 20 : floor;
        
        for (i = 0; i < (n || 12); i++) {
            data.push({
                name: Ext.Date.monthNames[i % 12],
                data1: Math.floor(Math.max((Math.random() * 100), floor)),
                data2: Math.floor(Math.max((Math.random() * 100), floor)),
                data3: Math.floor(Math.max((Math.random() * 100), floor)),
                data4: Math.floor(Math.max((Math.random() * 100), floor)),
                data5: Math.floor(Math.max((Math.random() * 100), floor)),
                data6: Math.floor(Math.max((Math.random() * 100), floor)),
                data7: Math.floor(Math.max((Math.random() * 100), floor)),
                data8: Math.floor(Math.max((Math.random() * 100), floor)),
                data9: Math.floor(Math.max((Math.random() * 100), floor))
            });
        }
        return data;
    };
    
    window.generateDataNegative = function(n, floor){
        var data = [],
            p = (Math.random() *  11) + 1,
            i;
            
        floor = (!floor && floor !== 0)? 20 : floor;
            
        for (i = 0; i < (n || 12); i++) {
            data.push({
                name: Ext.Date.monthNames[i % 12],
                data1: Math.floor(((Math.random() - 0.5) * 100), floor),
                data2: Math.floor(((Math.random() - 0.5) * 100), floor),
                data3: Math.floor(((Math.random() - 0.5) * 100), floor),
                data4: Math.floor(((Math.random() - 0.5) * 100), floor),
                data5: Math.floor(((Math.random() - 0.5) * 100), floor),
                data6: Math.floor(((Math.random() - 0.5) * 100), floor),
                data7: Math.floor(((Math.random() - 0.5) * 100), floor),
                data8: Math.floor(((Math.random() - 0.5) * 100), floor),
                data9: Math.floor(((Math.random() - 0.5) * 100), floor)
            });
        }
        return data;
    };

    window.store1 = Ext.create('Ext.data.JsonStore', {
        fields: ['name', 'data1', 'data2', 'data3', 'data4', 'data5', 'data6', 'data7', 'data9', 'data9'],
        data: generateData()
    });
    window.storeNegatives = Ext.create('Ext.data.JsonStore', {
        fields: ['name', 'data1', 'data2', 'data3', 'data4', 'data5', 'data6', 'data7', 'data9', 'data9'],
        data: generateDataNegative()
    });
    window.store3 = Ext.create('Ext.data.JsonStore', {
        fields: ['name', 'data1', 'data2', 'data3', 'data4', 'data5', 'data6', 'data7', 'data9', 'data9'],
        data: generateData()
    });
    window.store4 = Ext.create('Ext.data.JsonStore', {
        fields: ['name', 'data1', 'data2', 'data3', 'data4', 'data5', 'data6', 'data7', 'data9', 'data9'],
        data: generateData()
    });
    window.store5 = Ext.create('Ext.data.JsonStore', {
        fields: ['name', 'data1', 'data2', 'data3', 'data4', 'data5', 'data6', 'data7', 'data9', 'data9'],
        data: generateData()
    });    
    








    store1.loadData(generateData(8));

    var chart = Ext.create('Ext.chart.Chart', {
            id: 'chartCmp',
            xtype: 'chart',
            style: 'background:#fff',
            animate: true,
            theme: 'Category4',
            store: store1,
            // axes: [{
                // type: 'Numeric',
                // position: 'left',
                // fields: ['data1', 'data2', 'data3'],
                // title: 'Number of Hits',
                // grid: true
            // }, {
                // type: 'Category',
                // position: 'bottom',
                // fields: ['name'],
                // title: 'Month of the Year'
            // },
			// {
                // type: 'Category',
                // position: 'right',
                // fields: ['name'],
                // title: 'Month of the Year'
            // }
			// ],
            series: [
			{
                type: 'bar',
                axis: 'left',
	            xField: 'name',
                yField: 'data1',
              }, {
                type: 'line',
                axis: 'right',
				//style:'color:blue',
                xField: 'name',
                yField: 'data2',
               
            }]
    
    
        });
 

    var win = Ext.create('Ext.Window', {
        width: 800,
        height: 200,
        minHeight: 400,
        minWidth: 550,
        hidden: false,
        maximizable: true,
        title: 'Mixed Charts',
        renderTo: Ext.getBody(),
        layout: 'fit',
        tbar: [{
            text: 'Save Chart',
            handler: function() {
                Ext.MessageBox.confirm('Confirm Download', 'Would you like to download the chart as an image?', function(choice){
                    if(choice == 'yes'){
                        chart.save({
                            type: 'image/png'
                        });
                    }
                });
            }
        }, {
            text: 'Reload Data',
            handler: function() {
                store1.loadData(generateData(8));
            }
        }, {
            enableToggle: true,
            pressed: true,
            text: 'Animate',
            toggleHandler: function(btn, pressed) {
                var chart = Ext.getCmp('chartCmp');
                chart.animate = pressed ? { easing: 'ease', duration: 500 } : false;
            }
        }],
        items: chart
    });
});