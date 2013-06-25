/* 
 * Nirmal Kumar K S
 *
 */

Ext.define('AFE.store.TopAFEClassesStore', {
    extend: 'Ext.data.Store',
    model: 'AFE.model.AFEClassModel',
    autoLoad: true,
    proxy: {
        type: 'ajax',
        url: 'resources/data/TopAFEClasses.json',
        reader: {
            type: 'json'
        }
    },
    listeners: {
        'load': function(){
            globalObject.getController('TopAFEClassesController').onSetPieChartSeriesTitle(this);
        }
    }
    
});

