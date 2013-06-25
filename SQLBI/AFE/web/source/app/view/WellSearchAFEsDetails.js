/* 
 * Merrin J
 */


Ext.define('AFE.view.WellSearchAFEsDetails',
{
    extend:'Ext.panel.Panel',
    alias:'widget.wellSearchAFEsDetails',
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
                 width:'30%',
                layout:{
                    type:'hbox',
                     align:'stretch'
                },
                items:[{
                    flex:1,
                      bodyStyle:'background:transparent;color:white',
                    border:false
                },
                {
                    xtype:'label' ,
                    text:'AFE Details',
                    flex:3,
                    width:'10%'
                },
                {
                    xtype:'label' ,
                    text:'1/1/2012 - 6/30/2012',
                        
                    cls:'titleDate',
                    flex:7
                }
                ],
                flex:3,
                border:false,
                bodyStyle:'background:transparent;color:white'
            },
            {
                flex:7,
                  width:'70%',
                border:false
            }
            ]
        },
        {
            bodyStyle:'border-color:#000',
            id:'invoiceGridContainer',
            flex:10,
            width:'100%',
            layout:{
                type: 'vbox',
                align: 'stretch'
            },
            items:[
            {
                xtype:'wellSearchAFEDetailsGridView'
            }
            ]
        }
        ];
        this.callParent(arguments);

    }
});
