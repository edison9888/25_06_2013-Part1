/* 
 * 
 * Vishnu C
 */



Ext.define('AFE.controller.AFESearchController', {
    extend: 'Ext.app.Controller',
    views: [
    'AFESearchView',
    'AFESearchContainerView',
    'AFEDetailsView',
    'AFEDetailsByInvoiceView',
    'AFEBurnDownView',
    'BurnDownChartView',
    'InvoiceGridView',
    'InvoiceView',
    'InvoicesByBillingCategoryView',
    'NoOfInvoicesSubGridView'
    ],
    stores: [
    'AFEBurnDownStore',
    'InvoiceStore',
    'InvoiceBillingCategoryStore'
    ],
    models: [
    'AFEBurnDownItemModel',
    'InvoiceModel',
    'InvoiceBillingCategoryModel'

    ],
    init: function() {
        console.log('Initialized Users! This happens before the Application launch function is called');
        this.control(
        {
            'afeSearchView button[action=AFESearch]': {
                click:this.onAFESearchClik
            }
//            ,
//            'invoiceView radiogroup[id=invoiceRadio]': {
//                change:this.onInvoiceToggle
//            }
        }
        );
    },
    onAFESearchClik:function(){

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
        this.getAFENumber();
        
    },
    onInvoiceToggle:function(rb, newValue, oldValue, options){

       var selection = newValue.invoicesRadio;
        if(selection == 'BillingCategory'){
            
            var component=Ext.getCmp('afeSearchContainer');
            if(component.items.length>1){
                component.remove(component.items.first(), true);
            }
            component.add(0,{
                xtype:'afeDetailsView',
                margin:'5 5 5 5',
                flex:1,
                border:false           
            });
            component.doLayout();


            var component=Ext.getCmp('invoiceGridContainer');
            component.remove(component.items.first(), true);

            component.add(0,{
                xtype:'invoicesByBillingCategoryView',
                margin:'5 5 5 5',
                flex:1,
                border:false
            });
            component.doLayout();

           this.getAFENumber();
  
        } else if(selection == 'Invoice'){
           
            var component=Ext.getCmp('afeSearchContainer');
            if(component.items.length>1){
                component.remove(component.items.first(), true);
            }
            component.add(0,{
                xtype:'afeDetailsByInvoiceView',
                margin:'5 5 5 5',
                flex:1,
                border:false
            });
            component.doLayout();

            var component=Ext.getCmp('invoiceGridContainer');

            component.remove(component.items.first(), true);

            component.add(0,{
                xtype:'invoiceGridView',
                margin:'5 5 5 5',
                flex:1,
                border:false
            });
            component.doLayout();
            
             var afenumber = Ext.getCmp('afenumber').value;
        var headerText = Ext.getCmp('AfeHeaderTextInvoice');
        headerText.setText("AFEDetails - "+afenumber);
        }
    },
    getAFENumber:function(){
        var afenumber = Ext.getCmp('afenumber').value;
        var headerText = Ext.getCmp('AfeHeaderText');
        headerText.setText("AFEDetails - "+afenumber);
    },
    onAFEBurnDownToggle:function(rb, newValue, oldValue, options){
        var selection = newValue.radioAFEBurnDown;
        var burnDownChartView = Ext.getCmp('burnDownChart');
        if(selection == 'FieldEstimate'){
            burnDownChartView.series.items[1].title = 'Field Estimate';
            burnDownChartView.series.items[1].yField = 'FieldEstimate';
            burnDownChartView.series.items[2].yField = 'CumulativeFieldEstimate';
        } else if(selection == 'Actuals'){
            burnDownChartView.series.items[1].title = 'Actuals';
            burnDownChartView.series.items[1].yField = 'Actual';
            burnDownChartView.series.items[2].yField = 'CumulativeActual';
        }
        burnDownChartView.redraw();
    },
    onInvoiceClick:function(view, record, item, index, e, eOpts){
      var pop = new Ext.Window({
                width: 400,
                title: "Invoice Details",
                modal : true,
                items:[{
                        xtype:'noOfInvoicesSubGridView'
                }]
    })
    pop.show();
    }
});



