/*
 * 
 * Merrin J
 */


Ext.define('AFE.view.BarChartContainerView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.barChartContainerView',
    width:'100%',
    initComponent: function() {
        this.flex=1;
        this.layout={
            type: 'vbox',
            align: 'stretch'
        };
        this. items= [
        {
            border:false,
            width:'100%',
            layout:{
                type: 'vbox',
                align: 'stretch'
            },
            items:[{
                flex:1,
                border:false,
                layout:{
                    type: 'hbox',
                    align: 'stretch'
                },
                items:[
                {
                    xtype:'barChartView',
                    flex:4
                },
                {

                    flex:1,
                    border:false,
                    layout:{
                        type: 'vbox',
                        align: 'stretch'

                    },
                    items:[{

                        border:false,
                        xtype:'panel',
                        flex:10,
                        text:''
                    },
                    {
                        xtype:'panel',
                        flex:1,
                        html:'Show All',
                        action:'showAllAFEs',
                        border:false,
                        cls:'showAll',
                        listeners : {
                            render : function(c) {
                                c.getEl().on('click', function(){
                                    this.fireEvent('click', c);//fire the click event of panel
                                }, c);
                            }
                        }
                    }]
                }
                ]
            }
            ],
            flex:12

        }
        
        ];
        this.callParent(arguments);
    }
});