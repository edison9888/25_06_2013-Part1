Ext.application({
   name: 'MyApp',
   views:['ContentView'] ,
   launch: function() {
	var colors = ['blue','blue','green','green' ,'yellow','yellow','violet','violet','red','red'];
		Ext.chart.theme.Rainbow = Ext.extend(Ext.chart.theme.Base, {
			constructor: function(config) {
				Ext.chart.theme.Base.prototype.constructor.call(this, Ext.apply({
					colors: colors
				}, config));
			}
		});
		
	var store = Ext.create('Ext.data.JsonStore', {
		fields: ['name', 'data1', 'data2', 'data3', 'data4', 'data5'],
		data: [
			{'name':'', 'data1':10, 'data2':12, 'data3':14, 'data4':8, 'data5':13},
			{'name':'', 'data1':14, 'data2':5, 'data3':16, 'data4':10, 'data5':3},
			{'name':'', 'data1':18, 'data2':2, 'data3':14, 'data4':12, 'data5':7},
			{'name':'', 'data1':23, 'data2':14, 'data3':6, 'data4':1, 'data5':23},
			{'name':'', 'data1':27, 'data2':38, 'data3':36, 'data4':13, 'data5':33}
		],
	
	});
	
	
	Ext.create('Ext.chart.Chart', {
		renderTo: Ext.getBody(),
		width: 500,
		height: 400,
	   // animate: true,
		store: store,
		theme:'Rainbow',
	
		axes: [{
				type: 'Numeric',
				position: 'bottom',
				fields: ['data1','data2'],
				hidden:true,
				
			   /* label: {
					renderer: Ext.util.Format.numberRenderer('0,0')
				},      
				grid: true,  */
				minimum: 0
			}, 
			{
				type: 'Category',
				position: 'left',
				fields: ['name'],
				hidden:true,	
			},
	
		],
		series: [{
				type: 'bar',
				axis: 'bottom',
				highlight: false,
				gutter:100,
				height:50,
				//xPadding:50,
				/*tips: {
				  trackMouse: true,
				  
				  width: 140,
				  height: 20,
				  renderer: function(storeItem, item) {
					this.setTitle(storeItem.get('name') + ': ' + storeItem.get('data1') + ' views');
				  }
				},*/
				 label: {
					display: 'outside',
					field: 'data1',
					renderer: Ext.util.Format.numberRenderer('0'),
					orientation: 'horizontal',
					color: '#333',
					'text-anchor': 'middle'
				},
				
				xField: 'name',
				yField: ['data1','data2'],
				renderer: function(sprite, storeItem, barAttr, i, store) {
                    barAttr.fill = colors[i % colors.length];
					if(i == 1 || i==3 || i== 5 ||  i==7|| i== 9){
					barAttr.height=2;
					
					}
                    return barAttr;	
                },
			
		}]
	});
	}	
    });
				
				
	
		