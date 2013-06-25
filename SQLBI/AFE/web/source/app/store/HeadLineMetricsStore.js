/* 
 * Vishnu C
 */


Ext.define('AFE.store.HeadLineMetricsStore', {
    extend: 'Ext.data.Store',
    model: 'AFE.model.HeadLineMetricsModel',
    proxy: {
        type: 'ajax',
        url: 'resources/data/HeadLineMetrics.json',
        reader: {
            type: 'json'
        }
    },
    autoLoad: true,
    listeners: {
        'load': function(){
                    
            globalObject.getController('HeadlineMetricsController').loadDataFromStore(this);
        }
    }
});
