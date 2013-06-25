// Ext.Loader.setConfig({
// enabled:true
// });
// Ext.require([
// 'Ext.ux.layout.Center'  
// ]);
Ext.require('Ext.chart.*');
Ext.require('Ext.ux.grid.FiltersFeature');
Ext.application({
    name: 'AFE',
    appFolder: 'app',
    autoCreateViewport: true,
    controllers: 
    [
    'MainViewController',
    'OrganizationSummaryController',
    'AFESearchController',
    'WellSearchController',
    'ContentHeaderViewController',
    'ContentsViewController',
    'ProjectWatchListController',
    'TopBudgetedAFEController',
    'TopAFEClassesController',
    'HeadlineMetricsController'

    ],
 
    launch: function() {
        globalObject=this;
    // Ext.create('Ext.container.Viewport', {
    // layout: 'fit',
    // defaults: {autoScroll: true},
    // items: [
    // {
    // xtype:'mainView'
              
    // }
    // ]
    // });
    // init();
    //         globalObject.getController('OrganizationSummaryController').loadDataToHeatMap();
    }
});