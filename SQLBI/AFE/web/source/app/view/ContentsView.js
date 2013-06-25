/* 
 * 
 * Vishnu C
 */


Ext.define('AFE.view.ContentsView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.contentsView',

    initComponent: function() {
        this.layout={
            type: 'vbox'

        };
        this.items=[
        {
            xtype:'panel',
            flex:1,
            width:'100%',
            border:false,
            layout: {
                type: 'hbox',
                align: 'stretch'
            },
            items:[
            {
                xtype:'headlineMetricsView',
                margin:'5 5 5 5',
                flex:1,
                border:false
            },
            {
                xtype:'topAFEClassesView',
                margin:'5 5 5 5',
                flex:1,
                border:false
            }
            ]
        }
        ,{
            xtype:'panel',
            flex:1,
            width:'100%',
            border:false,
            layout: {
                type: 'hbox',
                align: 'stretch'
            },
            items:[
            {
                xtype:'topBudgetedAFEView',
                margin:'5 5 5 5',
                flex:1,
                border:false
            },
            {
                xtype:'projectWatchListView',
                margin:'5 5 5 5',
                flex:1,
                border:false
            }
            ]
               
        }
        ];
        this.callParent(arguments);
    }
});