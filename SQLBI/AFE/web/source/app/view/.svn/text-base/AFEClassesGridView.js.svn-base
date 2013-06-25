/* 
 * Nirmal Kumar
 */

var afeClassesGridFilters = {
    ftype: 'filters',
    // encode and local configuration options defined previously for easier reuse
    encode: false, // json encode the filter query
    local: true, // defaults to false (remote filtering)
    filters: [{
        type: 'string',
        dataIndex: 'AFEClassName'
    },{
        type: 'numeric',
        dataIndex: 'AFECount'
    },{
        type: 'numeric',
        dataIndex: 'Budget'
    },{
        type: 'numeric',
        dataIndex: 'FieldEstimate'
    },{
        type: 'numeric',
        dataIndex: 'TotActuals'
    },{
        type: 'numeric',
        dataIndex: 'Total'
    }]
};

Ext.define('AFE.view.AFEClassesGridView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.afeClassesGridView',
    width: '100%',
    layout: 'fit',
    initComponent: function() {
        this.flex=6;
        this.bodyStyle = 'border-color:#000';
        this.border=false;
        this.padding=7;
        this.items =[{
            xtype:'grid',
            id: 'afeClassesGrid',
            width:'100%',
            border: false,
            frame: true,
            autoScroll: true,
            columnLines: true,           
            cls:'topAFEClassesGrid',
            store:'AllAFEClassesStore',
            features: [afeClassesGridFilters],
            enableColumnMove: false,           
            selType: 'cellmodel',
            listeners : {
                cellclick:function(table, td, cellIndex, record, tr, rowIndex, e, eOpts)
                {  //Call controller Method
                    globalObject.getController('TopAFEClassesController').onAFEClassNameSelect(table, td, cellIndex, record, tr, rowIndex, e, eOpts);
                }
            },
            dockedItems: [{
                xtype: 'toolbar',
                dock: 'top',
                layout:{
                    pack: 'end'
                },
                items: [
                {
                    xtype: 'exporterbutton',
                    text: 'Export Grid Data'
                }
                ]
            }
            /*,
            {
                xtype: 'pagingtoolbar',
                store: 'AllAFEClassesStore',
                dock: 'bottom',
                displayInfo: true,
                emptyMsg: "No data available"
            }*/
            ],
            columns: [
            {
                text: 'Class',
                dataIndex: 'AFEClassName',
                flex: 1,
                renderer: function(val) {
                    return '<div style="text-decoration: underline; color: blue; cursor:pointer;">'+ val+'</div>';
                }
            },
            {
                text: 'No. of AFEs',
                dataIndex: 'AFECount',
                flex: 1
            },
            {
                text: 'AFE Estimate',
                dataIndex: 'Budget',
                flex: 1,
                renderer: 'usMoney'
            },
            {
                text: 'Accruals',
                dataIndex: 'FieldEstimate',
                flex: 1,
                renderer: 'usMoney'
            },
            {
                text: 'Actuals',
                dataIndex: 'TotActuals',
                flex: 1,
                renderer: 'usMoney'
            },
            {
                text: 'Total',
                dataIndex: 'Total',
                flex: 1,
                renderer: 'usMoney'
            }
            ]
        }]
        this.callParent(arguments);
    }
});