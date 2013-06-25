/* 
 * Merrin J
 */
Ext.define('AFE.store.TopBudgetedBarStore', {
    extend: 'Ext.data.Store',

    model: 'AFE.model.TopBudgetedBarModel',

    autoLoad: true,

    proxy: {
        type: 'ajax',
        url: 'resources/data/TopBudgetedBars.json',
        reader: {
            type: 'json'

        }
    },
    listeners: {
		'load': function(){

                globalObject.getController('TopBudgetedAFEController').sortBudgetInAsc(this);
                }
	 }
});

