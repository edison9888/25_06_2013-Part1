/* 
 * 
 * Vishnu C
 */



Ext.define('AFE.controller.OrganizationSummaryController', {
    extend: 'Ext.app.Controller',
    views: [
    'OrganizationSummaryView'
    ],
    stores: [
    'OrganizationTypeStore',
    'OrganizationNameStore',
    'StatusStore'

    ],
    models: [
    'OrganizationTypeModel',
    'OrganizationNameModel',
    'StatusModel'
    ],
    init: function() {

        this.control(
        {
            'organizationSummaryView button[action=Search]': {
                click:this.onSearchClick

            }
        }
        );
    },
    onSelectOrganizationType:function(combo, value){
       
        var organizationNameStore= Ext.getStore('OrganizationNameStore');
        Ext.getCmp('organizationNameCombo').reset();
        organizationNameStore.getProxy().url=organizationBaseUrl+combo.getValue();
        organizationNameStore.load();
    },
    onSearchClick:function(){
     var store=Ext.getStore('AFEsByClassStore');
       
    this.loadDataToHeatMap(store);
     
    },
    loadDataToHeatMap:function(store){
       var component=Ext.getCmp('contentContainer');
        if(component.items.length>0){
            component.remove(component.items.first(), true);
        }
        component.add(0,{
            xtype:'contentsView',
            layout: 'fit',
            border: false, 
            region: 'center',
            margins: '0 0 0 0'
        });
        component.doLayout();
      
            for(var i=0;i<store.data.items.length&& i<heatMapDisplayCount;i++)
            {
                var contentjsonObject= {
          
                    "data": {
                        "details":"AFE Estimate: $1,000,000<br/> Field Estimate: $"+store.data.items[i].data.FieldEstimate+"<br/>%Consumption: 200%",
                        "$color":heatMapColors[i], 
              
                        "$area": store.data.items[i].data.FieldEstimatePercent
                    }, 
                    "id": "AFE: "+store.data.items[i].data.AFENumber, 
                    "name": "AFE: "+store.data.items[i].data.AFENumber+"<br/> AFE Estimate: $1,000,000<br/> Field Estimate: $"+store.data.items[i].data.FieldEstimate+"<br/>%Consumption: 200%"
                };
                heatMapJson.children[i]=contentjsonObject;
            }
            if(store.data.items.length>0){
            initHeatMap();
              }
      
       
    }
    
    
});