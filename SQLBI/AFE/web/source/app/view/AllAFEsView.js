/* 
 *
 * Merrin J
 */
Ext.define('AFE.view.AllAFEsView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.allAFEsView',
    initComponent: function() {
        this.flex=20;
      //  this.bodyStyle = 'border-color:#000';
        this.border=false;
        this.padding=7;
        this.layout={
            type:'vbox',
            align:'stretch'
        };
        this.items =[{
            xtype:'grid',
            width:'100%',
            frame: true,
            columnLines:true,
            cls:'topAFEClassesGrid',
           // bodyStyle:'border-color:#000',
            border:false,
            store:'AllAFEsStore',
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
                flex: 1
            },
            {
                text: 'AFE Estimate',
                dataIndex: 'Budget',
                flex: 1
            },
            {
                text: 'Field Estimate',
                dataIndex: 'FieldEstimate',
                flex:1
            },
            {
                text: 'Actuals',
                dataIndex: 'Actual',
                flex:1
            }
            ],
            flex:1
          //  bodyStyle:'border-color:#000'
        }]
        this.callParent(arguments);
    }
});