/*
 * Merrin J
 */

Ext.define('AFE.view.InvoicesByBillingCategoryView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.invoicesByBillingCategoryView',
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
                listeners : {
                itemclick:function(view, record, item, index, e, eOpts)
                {  //Call controller Method
                    globalObject.getController('AFESearchController').onInvoiceClick(view, record, item, index, e, eOpts);
                }
            },
           
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
                        text: 'Billing Category Code',
                        dataIndex: 'BillingCategoryID',
                        flex: 1
                    },
                    {
                        text: 'Billing Category Name',
                        dataIndex: 'BillingCategoryName',
                        flex: 1
                    },
                    {
                        text: 'AFE Estimate',
                        dataIndex: '',
                        flex:1
                    },
                   
                    {
                        text: 'Actual',
                        dataIndex: 'ActualsAsStr',
                        flex: 1
                    },
                     {
                        text: 'Accrual',
                        dataIndex: 'FieldEstimateAsStr',
                        flex: 1
                    },
                    {
                        text: 'No of Invoices',
                        dataIndex: 'InvoiceCount',
                        flex: 1,
                   
                        renderer: function(val) {
                    return '<div style="text-decoration: underline; color: blue; cursor:pointer;">'+ val+'</div>';
                }
                    }

           
                    ],
                    flex:1

                }]
            this.callParent(arguments);
        }
    });
