Ext.define('afeStore', {
		extend: 'Ext.data.Model',
		fields: [
		   {name: 'afeName', type: 'string'},
		   {name: 'data', type: 'int'}
		]
	});
	
	
	var afe = Ext.create('Ext.data.Store', {
    model: 'afeStore',
    proxy: {
        type: 'ajax', 
        url: './resources/json/pie.json',
        reader: {
            type: 'json',
            root: 'afedata'
        }
    },
	autoLoad: true
});


Ext.onReady(function(){
	Ext.create('Ext.chart.Chart', {
		renderTo: Ext.getBody(),
		width: 500,
		height: 300,
		animate: true,
		store: afe,
		legend: {
			boxStrokeWidth: 0,
			position: 'right'
		},
		theme: 'Base:gradients',
		series: [{
			type: 'pie',
			field: 'data',
			title: ['DRLG','FACIL','RECMP','WO','OTH'],
			showInLegend: true,
			colorSet:	['#4D82BD','#C2504E','#9BBC55','#8065A2','#44ABC6'],
			tips: {
			  trackMouse: true,
			  width: 140,
			  height: 28,
			  renderer: function(storeItem, item) {
				//calculate and display percentage on hover
				var total = 0;
				afe.each(function(rec) {
					total += rec.get('data');
				});
				this.setTitle(storeItem.get('afeName') + ': ' + Math.round(storeItem.get('data') / total * 100) + '%');
			  }
			},
			label: {
				field: 'data',
				display: 'insideEnd',
				contrast: true,
				font: '18px Arial'
			}
		}]    
	});
});