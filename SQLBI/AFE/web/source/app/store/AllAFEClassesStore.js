/* 
 * Nirmal Kumar K S
 */

Ext.define('AFE.store.AllAFEClassesStore', {
    extend: 'Ext.data.Store',
    model: 'AFE.model.AFEClassModel',
    proxy: {
        type: 'ajax',
        url: 'resources/data/AllAFEClasses.json',
        reader: {
            type: 'json'
        }
    },
    autoLoad: true
});

