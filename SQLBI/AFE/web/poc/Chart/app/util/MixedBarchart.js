Ext.application({
   name: 'MyApp',
   views:['ContentView'] ,
   launch: function() {
	var colors = ['blue','green','yellow','violet','red'];
		Ext.chart.theme.Rainbow = Ext.extend(Ext.chart.theme.Base, {
			constructor: function(config) {
				Ext.chart.theme.Base.prototype.constructor.call(this, Ext.apply({
					colors: colors
				}, config));
			}
		});
	
	var store = Ext.create('Ext.data.JsonStore', {
		fields: ['name', 'a','data1', 'data2', 'data3', 'data4', 'data5'],
		data: [
			{'name':'a','a':'m', 'data1':1, 'data2':2, 'data3':11, 'data4':8, 'data5':13},
			{'name':'b','a':'m', 'data1':2, 'data2':3, 'data3':12, 'data4':10, 'data5':3},
			{'name':'c','a':'v', 'data1':3, 'data2':4, 'data3':13, 'data4':12, 'data5':7},
			{'name':'d', 'a':'m','data1':4, 'data2':3, 'data3':14, 'data4':1, 'data5':23},
			{'name':'e','a':'m', 'data1':5, 'data2':2, 'data3':15, 'data4':13, 'data5':33}
		],
	
	});	

	Ext.create('Ext.chart.Chart', {
		renderTo: Ext.getBody(),
		width: 400,
		height: 400,
		store: store,
		theme:'Rainbow',
	
		axes: 
		[
		    {   //x-axis
				type: 'Numeric',
				position: 'bottom',
				fields: ['data1','data3']
				
			}, 
			{
			    //y - axis
				type: 'Category',
				position: 'left',
				fields: ['name','a']
			},
			
		],
		series: 
		[				
				{
				type: 'bar',
				axis: 'left',
				//gutter:50,
				//yPadding:50,
				xField: 'name',
				yField: 'data1',				
				label: {
						display: 'outside',
						field: 'data1',
						renderer: Ext.util.Format.numberRenderer('0'),
						orientation: 'horizontal',
						color: '#333',
						'text-anchor': 'middle'
					},
						renderer: function(sprite, storeItem, barAttr, i, store) {
						barAttr.fill = colors[i % colors.length];
						barAttr.height=20;
						return barAttr;	
						}					
				},
				{
				type: 'bar',
				axis: 'left',
				//gutter:50,
				//yPadding:50,
				xField: 'a',
				yField: 'data3',				
				label: {
						display: 'insideStart',
						field: 'data1',
						renderer: Ext.util.Format.numberRenderer('0'),
						orientation: 'horizontal',
						color: '#333',
						'text-anchor': 'middle'
					},
						renderer: function(sprite, storeItem, barAttr, i, store) {
						barAttr.fill = colors[i % colors.length];
						barAttr.height=2;
						return barAttr;	
						}					
				},
				
				
				
			
		]
	});
		
	}	
    });
				
				
	
		