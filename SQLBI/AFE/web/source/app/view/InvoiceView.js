/* 
 * 
 * 
 */

Ext.define('AFE.view.InvoiceView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.invoiceView',

    initComponent: function() {
    
        this.layout={
            type: 'vbox'
        };
        this. items= [
        {
            baseCls:'contentHeader',
            flex:1,
            width:'100%',
            layout: {
                type: 'hbox',
                pack: 'start',
                align: 'middle'
            },
            items:[
            {
                xtype:'panel',
                layout:{
                    type:'hbox'
                },
                items:[{
                    flex:1,
                    
                    border:false
                },
                {
                    xtype:'label' , 
                    text:'Invoices',
                    flex:5
                }
                ],
                flex:1,
                border:false,
                bodyStyle:'background:transparent;color:white'
            },
            {
                flex:8,
                border:false,
                
                xtype:'panel',
                bodyStyle:'background:transparent;color:white',
                layout:{
                    type:'hbox',
                    align: 'middle'
                },
                  
                items:[{
                    xtype:'label' ,
                    text:'1/1/2012 - 6/30/2012',
                        
                    cls:'titleDate'
                }]
                 
                
                
            },
            {
                xtype:'panel',
                border:false,
                flex: 4,
                bodyStyle:'background:transparent;color:white',
                layout:{
                    type:'hbox',
                    pack:'end',
                    align:'middle'
                },
                items:[{
                    xtype: 'radiogroup',
                    id: 'invoiceRadio',
                    columns: [50, 50],
                    // Arrange radio buttons into two columns, distributed vertically
                    columns: 2,
                    vertical: true,
                    flex:1,
                    items: [{
                        xtype: 'radiofield',
                        name:'invoicesRadio',
                        inputValue: 'BillingCategory',
                        action: 'invoiceByBillingCtegory',
                        style:'color:white;',
                        boxLabel: 'By Billing Category',
                        checked: true
//                        flex:1 
                    },
                    {
                        xtype: 'radiofield',
                        name: 'invoicesRadio',
                        inputValue: 'Invoice',
                        action: 'invoiceByInvoice',
                        style:'color:white',
                        boxLabel: 'By Invoice'
//                        flex:1
                    }],
                    listeners : {
                        change:function(rb, newValue, oldValue, options)
                        {
                            globalObject.getController('AFESearchController').onInvoiceToggle(rb, newValue, oldValue, options);
                        }
                    }

                }]
            },
            
            ]
        },
        {           
            bodyStyle:'border-color:#000',
            id:'invoiceGridContainer',
            flex:8,
            width:'100%',
            layout:{
                type: 'vbox',     
                align: 'stretch'
            },
            items:[
            {
                xtype:'invoicesByBillingCategoryView'
            }
            ]
        }
        ];
        this.callParent(arguments);
    
    }
});
