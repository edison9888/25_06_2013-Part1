/*
 * 
 * Merrin J
 */


Ext.define('AFE.view.AllAFEsContainerView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.allAFEsContainerView',
    width:'100%',
    initComponent: function() {
        this.flex=1;
        this.layout={
            type: 'vbox',
            align: 'stretch'
        };
        this. items= [
        {
             xtype:'allAFEsView',
            border:false,
            width:'100%',
            flex:20

        },{
            border:false,
            layout: {
                type: 'hbox',
                pack: 'end'
            },
            items:[{
              
                flex:1,
                border:false
            },{
                flex:3,
                border:false
            },
            {
                xtype:'panel' ,
                flex:20,
                layout:{
                    type:'hbox',
                    pack:'end'
                },
                items:[ {
                    xtype:'panel',
                    html:'Chart View',
                    action:'showChartView',
                     border:false,
                    cls:'showAll',
                    listeners : {
                        render : function(c) {
                            c.getEl().on('click', function(){
                                this.fireEvent('click', c);
                            }, c);
                        }
                    }   
                }
            ],
                border:false
            }
            ,{
                xtype:'panel' ,
                flex:1,
                border:false
            }
            ],
            flex:2
        }];
        this.callParent(arguments);
    }
});
