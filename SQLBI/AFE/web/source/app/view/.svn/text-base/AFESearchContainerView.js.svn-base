/* 
 * 
 * Merrin J
 */
Ext.define('AFE.view.AFESearchContainerView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.afeSearchContainerView',
    initComponent: function() {
        this.layout={
            type: 'vbox'
        };
        this.items=[
        {
            xtype:'panel',
            id:'afeSearchContainer',
            flex:1,
            width:'100%',
            border:false,
            layout: {
                type: 'hbox',
                align: 'stretch'
            },
            items:[
            {
                xtype:'afeDetailsView',
                margin:'5 5 5 5',
                flex:1,
                border:false
            },
            {
                xtype:'afeBurnDownView',
                margin:'5 5 5 5',
                flex:1,
                border:false
            }
            ]
        },{
            
            flex:1,
            margin:'5 5 5 5',
            flex:1,
            border:false,
            width:'100%',
            layout:{
                type: 'fit'
            },
            items:[
            {
                xtype:'invoiceView'                             
            }
            ]

        }
        ];
        this.callParent(arguments);
    }
});

