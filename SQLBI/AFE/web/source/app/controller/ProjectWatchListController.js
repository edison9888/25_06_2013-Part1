/* 
 * Vishnu C
 */



Ext.define('AFE.controller.ProjectWatchListController', {
    extend: 'Ext.app.Controller',
    views: [
   
    'ProjectWatchListView',
    'HeatMapView',
    'ProjectWatchListGridView'
    
    ],
    stores: [
    'AllProjectWatchListStore'
    
    ],
    models: [
     
    'AllProjectWatchListModel'
    ],
    init: function() {
        console.log('Initialized Users! This happens before the Application launch function is called');
        this.control(
        {
           
            'heatMapView panel[action=showAll]': {
                click :this.onShowAllClik 
            },
            'projectWatchListGridView panel[action=ShowMap]': {
                click:this.onShowMapClik
            }
           
        }
        );
    },
    onShowAllClik:function(){
   
        var component=Ext.getCmp('projectWatchListContent');
       
        component.remove(component.items.first(), true);
        component.add(0,{
            xtype:'projectWatchListGridView'
        });
        component.doLayout();
      /*  var selection = Ext.getCmp('projectWatchListRadio').getValue().radioProjectWatchList;
        if(selection == 'FieldEstimate'){ 
            var grid=Ext.getCmp('projectWatchListGrid');
            var column2=grid.headerCt.getComponent('fieldEstimateColumn');
            column2.dataIndex='FieldEstimate';
            column2.setText('Field Estimate');
            var column3=grid.headerCt.getComponent('consumptionColumn');
            column3.dataIndex='FieldEstimatePercent';
            grid.getView().refresh();
        
        } else if(selection == 'Actuals'){
            var grid=Ext.getCmp('projectWatchListGrid');
            var column2=grid.headerCt.getComponent('fieldEstimateColumn');
            column2.dataIndex='Actual';
            column2.setText('Actuals');
            var column3=grid.headerCt.getComponent('consumptionColumn');
            column3.dataIndex='ActualPercent';
            grid.getView().refresh(); 
        }*/
    }, 
    onShowMapClik:function(){
      
     
        var component=Ext.getCmp('projectWatchListContent');
        component.remove(component.items.first(), true);
        
        component.add(0,{
            xtype:'heatMapView'
        });
        component.doLayout();
        initHeatMap();
        
    },
    onClickRadioButton:function(rb, newValue, oldValue, options)
    {
        var selection = newValue.radioProjectWatchList;
       
        if(selection == 'FieldEstimate'){
            var store=Ext.getStore('AFEsByClassStore');
            for(var i=0;i<store.data.items.length;i++)
            {
                var contentjsonObject= {
          
                    "data": {
                        "details":"AFE Estimate:$1,000,000<br/>Field Estimate:$"+store.data.items[i].data.FieldEstimate+"<br/> %Consumption:200%",
                        "$color":heatMapColors[i], 
              
                        "$area": store.data.items[i].data.FieldEstimatePercent
                    }, 
                    "id": "AFE:"+store.data.items[i].data.AFENumber, 
                    "name": i==(store.data.items.length-1)?"AFE:"+store.data.items[i].data.AFENumber+"AFE Estimate:$1,000,000 <br/> Field Estimate:$"+store.data.items[i].data.FieldEstimate+"<br/> %Consumption:200%":" "
                };
                heatMapJson.children[i]=contentjsonObject;
            }
            
            var component=Ext.getCmp('projectWatchListContent');
            if(component.items.first().xtype!='projectWatchListGridView'){
                component.remove(component.items.first(), true);
        
                component.add(0,{
                    xtype:'heatMapView'
                });
               initHeatMap();
            }else{
                var grid=Ext.getCmp('projectWatchListGrid');
                var column2=grid.headerCt.getComponent('fieldEstimateColumn');
                column2.dataIndex='FieldEstimate';
                column2.setText('Field Estimate');
                var column3=grid.headerCt.getComponent('consumptionColumn');
                column3.dataIndex='FieldEstimatePercent';
                grid.getView().refresh();
            }

        } else if(selection == 'Actuals'){
            var store=Ext.getStore('AFEsByClassStore');
            for(var i=0;i<store.data.items.length;i++)
            {
                var contentjsonObject= {
          
                    "data": {
                        "details":"AFE Estimate:$1,000,000 <br/> Actuals:$"+store.data.items[i].data.Actual+"<br/> %Consumption:200%",
                        "$color":heatMapColors[i], 
              
                        "$area": store.data.items[i].data.ActualPercent
                    }, 
                    "id": "AFE:"+store.data.items[i].data.AFENumber, 
                    "name": i==(store.data.items.length-1)?"AFE:"+store.data.items[i].data.AFENumber+"<br/>AFE Estimate:$1,000,000 <br/> Actuals:$"+store.data.items[i].data.Actual+"<br/> %Consumption:200%":" "
                };
                heatMapJson.children[i]=contentjsonObject;
            }
            var component=Ext.getCmp('projectWatchListContent');
            if(component.items.first().xtype!='projectWatchListGridView'){
                component.remove(component.items.first(), true);
                 component.add(0,{
                    xtype:'heatMapView'
                });
                initHeatMap();
            }else{
                var grid=Ext.getCmp('projectWatchListGrid');
                var column2=grid.headerCt.getComponent('fieldEstimateColumn');
                column2.dataIndex='Actual';
                column2.setText('Actuals');
                var column3=grid.headerCt.getComponent('consumptionColumn');
                column3.dataIndex='ActualPercent';
                grid.getView().refresh();
            }
        }
    }
});