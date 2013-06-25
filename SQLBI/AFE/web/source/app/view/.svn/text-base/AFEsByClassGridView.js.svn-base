/* 
 * Nirmal Kumar
 */

var afesByClassGridFilters = {
    ftype: 'filters',
    // encode and local configuration options defined previously for easier reuse
    encode: false, // json encode the filter query
    local: true, // defaults to false (remote filtering)
    filters: [{
        type: 'string',
        dataIndex: 'Name'
    },{
        type: 'numeric',
        dataIndex: 'Budget'
    },{
        type: 'numeric',
        dataIndex: 'FieldEstimate'
    },{
        type: 'numeric',
        dataIndex: 'Actual'
    },{
        type: 'numeric',
        dataIndex: 'Total'
    }]
};

Ext.define('AFE.view.AFEsByClassGridView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.afesByClassGridView',
    width: '100%',
    layout: 'fit',
    initComponent: function() {
        this.flex=6;
        this.bodyStyle = 'border-color:#000';
        this.border=false;
        this.padding=7;
        this.items =[{
            xtype:'grid',
            width:'100%',
            border: false,
            frame: true,
            autoScroll: true,
            columnLines:true,
            cls:'topAFEClassesGrid',
            store:'AFEsByClassStore',
            features: [afesByClassGridFilters],
            enableColumnMove: false,
            selType: 'cellmodel',
            listeners : {
                cellclick:function(table, td, cellIndex, record, tr, rowIndex, e, eOpts)
                {  //Call controller Method
                    globalObject.getController('TopAFEClassesController').onAFENameSelect(table, td, cellIndex, record, tr, rowIndex, e, eOpts);
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
                    xtype: 'exporterbutton',//exportbutton
                    text: 'Export Grid Data'
                }
                ]
            }],
            columns: [
            {
                text: 'AFE',
                dataIndex: 'Name',
                flex: 1,
                renderer: function(val) {
                    return '<div style="text-decoration: underline; color: blue; cursor:pointer;">'+ val+'</div>';
                }
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
                flex:1,
                renderer: 'usMoney'
            },
            {
                text: 'Actuals',
                dataIndex: 'Actual',
                flex:1,
                renderer: 'usMoney'
            },
            {
                text: 'Total',
                dataIndex: 'Total',
                flex:1,
                renderer: 'usMoney'
            }
            ]          
        }]
        this.callParent(arguments);
    }
});