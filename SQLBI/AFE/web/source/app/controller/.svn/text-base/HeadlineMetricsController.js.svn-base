/* 
 *
 * Merrin j
 */


Ext.define('AFE.controller.HeadlineMetricsController', {
    extend: 'Ext.app.Controller',
    views: [
    'HeadlineMetricsView'
    ],
    stores: [
    'HeadLineMetricsStore'
    ],
    models: [
    'HeadLineMetricsModel'
    ],
    init: function() {
       
    },
    loadDataFromStore:function(store){
       
        var item=store.data.items.length>0?store.data.items[0]:null;
       
        if(item!=null){
            Ext.getCmp('headLineMetrcsNoOfAFE').setText(item.data.AFECount);
            Ext.getCmp('headLineMetrcsTotalAfeEstimate').setText('$'+item.data.TotalBudget+'MM');
            Ext.getCmp('headLineMetrcsTotalAccruals').setText('<div>$'+item.data.TotalFieldEstAsStr+'MM <span style="color:red">('+item.data.TotalFieldEstPercent+'%)*</span></div>',false);
            Ext.getCmp('headLineMetrcsActuals').setText('<div>$'+item.data.TotalActuals+'MM <span style="color:green">('+item.data.TotalActualsPercent+'%)*</span></div>',false);
            Ext.getCmp('headLineMetrcsAvgDurationOfAfe').setText(item.data.AvgAFEDuration);
            Ext.getCmp('headLineMetrcsSumOfActualsAndAccruals').setText('$'+item.data.AvgAFEBudget+'MM');
        }else{
            Ext.getCmp('headLineMetrcsNoOfAFE').setText(0);
            Ext.getCmp('headLineMetrcsTotalAfeEstimate').setText('$'+0+'MM');
            Ext.getCmp('headLineMetrcsTotalAccruals').setText('<div>$'+0+'MM <span style="color:red">('+0+'%)*</span></div>',false);
            Ext.getCmp('headLineMetrcsActuals').setText('<div>$'+0+'MM <span style="color:green">('+0+'%)*</span></div>',false);
            Ext.getCmp('headLineMetrcsAvgDurationOfAfe').setText(0);
            Ext.getCmp('headLineMetrcsSumOfActualsAndAccruals').setText('$'+0+'MM');
        }
    }
});