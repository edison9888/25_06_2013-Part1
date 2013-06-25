/* 
 * 
 * Merrin J
 */
Ext.define('AFE.store.AllAFEsStore', {
    extend: 'Ext.data.Store',
    model: 'AFE.model.AllAFEsModel',

    autoLoad: true,

    proxy: {
        type: 'ajax',
        url: 'resources/data/AllAFEs.json',
        reader: {
            type: 'json'

        }
    },
    listeners: {
		'load': function(){
                    
                globalObject.getController('OrganizationSummaryController').loadDataToHeatMap(this);
                }
	 }
});

