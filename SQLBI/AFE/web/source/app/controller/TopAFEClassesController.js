/* 
 * 
 * Nirmal Kumar
 */


Ext.define('AFE.controller.TopAFEClassesController', {
    extend: 'Ext.app.Controller',
    views: [  
    'TopAFEClassesView',
    'AFEClassesSummaryView',
    'AFEClassesView',
    'AFEsByClassView',
    'PieChartView',
    'AFEClassesGridView',
    'AFEsByClassGridView'
    ],
    stores: [
    'TopAFEClassesStore',
    'AllAFEClassesStore',
    'AFEsByClassStore'
    ],
    models: [
    'AFEClassModel',
    'AFEModel'
    ],
    init: function() {
        console.log('Initialized Users! This happens before the Application launch function is called');
        this.control(
        {
            'topAFEClassesView panel[action=showAFEClassesSummary]': {
                click:this.onShowAFEClassesSummary
            },
            'topAFEClassesView panel[action=showAFEClasses]': {
                click:this.onShowAFEClasses
            },
            'topAFEClassesView panel[action=showAFEsByClass]': {
                click:this.onShowAFEsByClass
            }
        }
        );
    },
    onSetPieChartSeriesTitle:function(store){
        var titleArray = new Array();
        var i=0;
        var pieChart = Ext.getCmp('pieChart');
        store.each(function(rec) {
            titleArray[i++]  = rec.get('AFEClassName');
        });
        if(pieChart != null){
            pieChart.series.items[0].title = titleArray;
            pieChart.redraw();
        }       
    },
    onShowAFEClassesSummary:function(){

        var component=Ext.getCmp('topAFEClassesViewContent');

        component.remove(component.items.first(), true);
        component.add(0,{
            xtype:'afeClassesSummaryView'
        });
        component.doLayout();

        component = Ext.getCmp('topAFEClassesHeaderLabel');
        component.setText('Top AFE Classes');
        
        component = Ext.getCmp('topAFEClassesRadio');
        component.setVisible(true);
    },
    onShowAFEClasses:function(){

        var component=Ext.getCmp('topAFEClassesViewContent');

        component.remove(component.items.first(), true);
        component.add(0,{
            xtype:'afeClassesView'
        });
        component.doLayout();

        component = Ext.getCmp('topAFEClassesHeaderLabel');
        component.setText('AFE Classes');
        
        component = Ext.getCmp('topAFEClassesRadio');
        component.setVisible(false);
    },
    onShowAFEsByClass:function(){

        var component=Ext.getCmp('topAFEClassesViewContent');

        component.remove(component.items.first(), true);
        component.add(0,{
            xtype:'afesByClassView'
        });
        component.doLayout();

        component = Ext.getCmp('topAFEClassesHeaderLabel');
        component.setText('AFE Classes');
        
        component = Ext.getCmp('topAFEClassesRadio');
        component.setVisible(false);
    },
    onTopAFEClassesToggle:function(rb, newValue, oldValue, options){
        var selection = newValue.radioTopAFEClasses;
        var pieChartView = Ext.getCmp('pieChart');
        var topAFEClassesStore = pieChartView.getStore();
        if(selection == 'Budget'){          
            topAFEClassesStore.getProxy().url = 'resources/data/TopAFEClasses.json';
            topAFEClassesStore.load();
            pieChartView.series.items[0].field = 'Budget';
            pieChartView.series.items[0].label.field = 'Budget';
            pieChartView.series.items[0].tipConfig.renderer = function(storeItem, item){
                var total = 0;
                topAFEClassesStore.each(function(rec) {
                    total += rec.get('Budget');
                });
                this.setTitle(storeItem.get('AFEClassName') + ': ' + Math.round(storeItem.get('Budget') / total * 100) + '%');
                
            };
        } else if(selection == 'AFECount'){
            topAFEClassesStore.getProxy().url = 'resources/data/TopAFEClasses1.json';
            topAFEClassesStore.load();
            pieChartView.series.items[0].field = 'AFECount';
            pieChartView.series.items[0].label.field = 'AFECount';
            pieChartView.series.items[0].tipConfig.renderer = function(storeItem, item){
                var total = 0;
                topAFEClassesStore.each(function(rec) {
                    total += rec.get('AFECount');
                });
                this.setTitle(storeItem.get('AFEClassName') + ': ' + Math.round(storeItem.get('AFECount') / total * 100) + '%');
                
            }; 
        }
    },
    onAFEClassNameSelect:function(table, td, cellIndex, record, tr, rowIndex, e, eOpts){     
        if(cellIndex == 0){
            //            alert(record.data.AFEClassName);
            var component=Ext.getCmp('topAFEClassesViewContent');

            component.remove(component.items.first(), true);
            component.add(0,{
                xtype:'afesByClassView'
            });
            component.doLayout();

            component = Ext.getCmp('topAFEClassesHeaderLabel');
            component.setText('AFE Classes');
        }      
    },
    onAFENameSelect:function(table, td, cellIndex, record, tr, rowIndex, e, eOpts){       
        if(cellIndex == 0){
            //            alert(record.data.Name);
            var component=Ext.getCmp('contentContainer');
            if(component.items.length>0){
                component.remove(component.items.first(), true);
            }
            component.add(0,{
                xtype:'afeSearchContainerView',
                layout: 'fit',
                border: false,
                region: 'center',
                margins: '0 0 0 0'
            });
            component.doLayout();
            var headerText = Ext.getCmp('AfeHeaderText');
            headerText.setText("AFEDetails - "+record.data.Name);
        }       
    }
});