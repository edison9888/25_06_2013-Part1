/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
Ext.define('AFE.view.WellSearchAFEDetailsGridView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.wellSearchAFEDetailsGridView',
    initComponent: function() {
        this.flex=20,
        this.padding=15;
        this.border=false;
        this.layout={
            type:'vbox',
            align:'stretch'
        };
        this.items =[{
            xtype:'grid',
            shadow:false,
            frame:true,
            columnLines:true,
            border:false,
            width: '100%',
            cls:'topAFEClassesGrid',
            store:'InvoiceBillingCategoryStore',
            
            //             tbar   : [
            //            {
            //                xtype: 'exporterbutton',//exportbutton
            //                text: 'Export'
            //
            //            //store: store
            //            }],
            dockedItems: [{
                xtype: 'toolbar',
                dock: 'top',
                layout:{
                    pack: 'end'
                },
                items: [
                {
                    xtype: 'exporterbutton',//exportbutton
                    text: 'Export'
                //                store: store
                }
                ]
            }],
            columns: [
            {
                text: 'AFE Number',
                dataIndex: 'BillingCategoryID',
                flex: 1
            },
            {
                text: 'Start Date',
                dataIndex: 'BillingCategoryName',
                flex: 1
            },
            {
                text: 'Status',
                dataIndex: '',
                flex:1
            },
            {
                text: 'AFE Estimate',
                dataIndex: 'FieldEstimateAsStr',
                flex: 1
            },
            {
                text: 'Actuals',
                dataIndex: 'ActualsAsStr',
                flex: 1
            },
            {
                text: 'Accruals',
                dataIndex: 'InvoiceCount',
                flex: 1
            },{
                text: 'Total',
                dataIndex: 'InvoiceCount',
                flex: 1
            },
            {
                text: 'Total/AFE Est(%)',
                dataIndex: 'InvoiceCount',
                flex: 1 
            }


            ],
            flex:1

        }]
        this.callParent(arguments);
    }
});


