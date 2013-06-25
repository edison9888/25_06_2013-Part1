/* 
 *
 * Vishnu C
 */


Ext.define('AFE.controller.TopBudgetedAFEController', {
    extend: 'Ext.app.Controller',
    views: [
    'TopBudgetedAFEView',
    'BarChartView',
    'BarChartContainerView',
    'AllAFEsView',
    'AllAFEsContainerView'
    ],
     stores: [
     'BarchartStore',
     'AllAFEsStore',
     'TopBudgetedBarStore'
     ],
     models: [
     'BarchartModel',
     'AllAFEsModel',
     'TopBudgetedBarModel'
     ],
    init: function() {
        console.log('Initialized Users! This happens before the Application launch function is called');

    this.control(
        {

            'topBudgetedAFEView panel[action=showAllAFEs]': {
                click:this.onShowAllClik
            },
           'allAFEsContainerView panel[action=showChartView]': {
                click:this.onShowMapClik
            },
            'topBudgetedAFEView radiogroup[id=topBudgetedAFERadio]': {
                change:this.onTopBudgetedAFEToggle
            }
        }
        );
    },
    onShowAllClik:function(){

        var component=Ext.getCmp('topBudgetedAFEViewContent');

        component.remove(component.items.first(), true);
        component.add(0,{
            xtype:'allAFEsContainerView'
        });
        component.doLayout();

    },
    onShowMapClik:function(){


        var component=Ext.getCmp('topBudgetedAFEViewContent');
        component.remove(component.items.first(), true);

        component.add(0,{
            xtype:'barChartContainerView'
        });
        component.doLayout();
        

    },
   onTopBudgetedAFEToggle:function(rb, newValue, oldValue, options){
        var selection = newValue.radioTopBudgetedAFE;
        var topBudgetedAFEsStore, barChartView;
      
       if(selection == 'FieldEstimate'){
             barChartView = Ext.getCmp('barChart');
            topBudgetedAFEsStore = barChartView.getStore();
            topBudgetedAFEsStore.getProxy().url = 'resources/data/AFEsByClass.json';
            topBudgetedAFEsStore.load();
            barChartView.series.xField = 'Name';
            barChartView.series.yField = ['Budget'];
        } else if(selection == 'Actuals'){
             barChartView = Ext.getCmp('barChart');
             topBudgetedAFEsStore = barChartView.getStore();
            topBudgetedAFEsStore.getProxy().url = 'resources/data/AFEsByClass.json';
            topBudgetedAFEsStore.load();
            barChartView.series.xField = 'Name';
            barChartView.series.yField = ['FieldEstimate'];
          
        }

    },
    sortBudgetInAsc:function(store){
      
        var len = store.data.items.length;
        var max = store.data.items[len-1].data.Budget;
        //alert(max);
        var component = Ext.getCmp('barChart');
        //alert(max+12000);
        component.axes.items[0].maximum = Number(max)+12000;
        component.redraw();

    }

});