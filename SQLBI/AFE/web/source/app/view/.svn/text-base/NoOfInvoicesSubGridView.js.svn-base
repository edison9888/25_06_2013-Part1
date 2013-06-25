/*
 * Merrin J
 */
Ext.define('AFE.view.NoOfInvoicesSubGridView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.noOfInvoicesSubGridView',
    width: '100%',
    layout: 'fit',
    initComponent: function() {
        this.flex=6;
        this.bodyStyle = 'border-color:#000';
        this.border=false;
        this.padding=10;
        this.items =[{
            xtype:'grid',
           // id: 'afeClassesGrid',
            width:'100%',
            frame: true,
            autoScroll: true,
            columnLines: true,

            cls:'topAFEClassesGrid',
            store:'BarchartStore',
//            dockedItems: [{
//                xtype: 'toolbar',
//                dock: 'top',
//                layout:{
//                    pack: 'end'
//                },
//                items: [
//                {
//                    xtype: 'exporterbutton',
//                    text: 'Export Grid Data'
//                }
//                ]
//            }
            /*,
            {
                xtype: 'pagingtoolbar',
                store: 'AllAFEClassesStore',
                dock: 'bottom',
                displayInfo: true,
                emptyMsg: "No data available"
            }*/
 //           ],
            columns: [
            {
                text: 'Vendor',
                dataIndex: 'Vendor',
                flex: 1,
                filter: {
                    type: 'string'
                }
               
            },
            {
                text: 'Invoice Date',
                dataIndex: 'InvoiceDate',
                flex: 1,
                filter: {
                    type: 'Date'
                }
            },
            {
                text: 'Service Date',
                dataIndex: 'ServiceDate',
                flex: 1,
                filter: {
                    type: 'Date'
                }
               
            },
            {
                text: 'Gross Expense',
                dataIndex: 'GrossExpense',
                flex: 1,
                filter: {
                    type: 'numeric'
                },
                renderer: 'usMoney'
            }
            
            ]
        }]
        this.callParent(arguments);
    }
});
