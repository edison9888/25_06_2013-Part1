/* 
 *
 * Vishnu C
 */


Ext.define('AFE.view.HeatMapView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.heatMapView',
    width:'100%',
    initComponent: function() {
        this.layout={
            type: 'vbox',    
            align: 'stretch'
        };
        this.items =[
        {
            xtype:'panel',
            id:'center-container',
            layout:{
                type: 'vbox',    
                align: 'stretch'
            },
            items:[{
                xtype:'panel',
                id:'infovis',
                flex:1,
                border:false
                             
                     
            }],
            flex:10,
            margins: '2 40 5 40',
            border:false
        },               
        {
              
            xtype:'panel',
            layout:{
                type:'hbox',
                pack:'end'
            },
            items:[{
                xtype:'panel' ,
                flex:20,
                    
                layout:{
                    type:'hbox',
                    pack:'end'
                },
                items:[ {
                    xtype:'panel',
                    html:'Show All',
                    border:false, 
                    action:'showAll',
                    cls:'showAll',
                    listeners : {
                        render : function(c) {
                            c.getEl().on('click', function(){
                                this.fireEvent('click', c);
                            }, c);
                        }
                    }
                       
                }],
                border:false
            }
            ,{
                xtype:'panel' ,
                flex:1,
                border:false
            }],
            border:false,
            flex:1 
        }];
        this.flex=1;
      
            
        this.callParent(arguments);
    }
});