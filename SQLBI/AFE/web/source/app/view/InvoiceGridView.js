/* 
 * Merrin J
 */

Ext.define('AFE.view.InvoiceGridView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.invoiceGridView',
    initComponent: function() {
        this.flex=20;
        this.padding=15;
         this.border=false;
        this.layout={
            type:'vbox',
            align:'stretch'
        };
        this.items =[{
            xtype:'grid',
            shadow:false,
            frame:'true',
            columnLines:true,
            border:false,
            width: '100%',
            cls:'topAFEClassesGrid',
            store:'InvoiceStore',
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
                text: 'Invoice No.',               
                dataIndex: 'InvoiceNumber',
                flex: 1
            },
            {
                text: 'Billing Category',
                dataIndex: 'BillingCategory',
                flex: 1
            },
            {
                text: 'Invoice Date',
                dataIndex: 'InvoiceDateAsStr',
                flex:1
            },
            {
                text: 'Invoice Amount',
                dataIndex: 'InvoiceAmount',
                flex: 1
            },
            {
                text: 'Property Name',
                dataIndex: 'PropertyName',
                flex: 1
            },
            {
                text: 'Property Type',
                dataIndex: 'PropertyType',
                flex: 1
            },
            {
                text: 'Service Date',
                dataIndex: 'ServiceDate',
                flex: 1
            },
            {
                text: 'Accting Date',
                dataIndex: 'AcctingDate',
                flex: 1
            },
            {
                text: 'Vendor Name',
                dataIndex: 'VendorName',
                flex: 1
            }
            ],
            flex:1
        }]
        this.callParent(arguments);
    }
});
