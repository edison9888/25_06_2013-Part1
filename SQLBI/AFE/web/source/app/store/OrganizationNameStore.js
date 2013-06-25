/* 
 * 
 * Vishnu C
 */


Ext.define('AFE.store.OrganizationNameStore', {
    extend: 'Ext.data.Store',
   
    model: 'AFE.model.OrganizationNameModel',
   
    autoLoad: true,
    autoDestroy: true,
    proxy: {
        type: 'jsonp',
        url: 'resources/data/Organizations.json',
        reader: {
            type: 'json'
                    
        }
    }
});