/* 
 * 
 * Vishnu C
 */


Ext.define('AFE.controller.WellSearchController', {
    extend: 'Ext.app.Controller',
    views: [
    'WellSearchView',
    'WellSearchAFEsDetails',
    'WellsearchContainerView',
    'WellSearchAFEDetailsGridView',
    'WellInformationView'
    ],
   init: function() {
        console.log('Initialized Users! This happens before the Application launch function is called');
        this.control(
        {
            'wellSearchView button[action=wellSearch]': {
                click:this.onWellSearchClik
            }
          
        }
    )
    },
    onWellSearchClik: function(){
    
      var component=Ext.getCmp('contentContainer');
        if(component.items.length>0){
            component.remove(component.items.first(), true);
        }
        component.add(0,{
            xtype:'wellsearchContainerView',
            layout: 'fit',
            border: false,
            region: 'center',
            margins: '0 0 0 0'
        });
        component.doLayout();
    }
});
