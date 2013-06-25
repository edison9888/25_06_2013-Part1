/* 
 *  Vishnu C
 */

Ext.Loader.setConfig({
    enabled:true
});
Ext.application({
   
    name: 'AFE',
    controllers: ['ChartController'],
    
    appFolder: 'app',
    launch: function() {
  
        
        Ext.create('Ext.container.Viewport', {
            layout: 'fit',
          
            items: [
            {
                xtype: 'heatChart'
               
            }
            ]
        });
      init();
    }
   
});