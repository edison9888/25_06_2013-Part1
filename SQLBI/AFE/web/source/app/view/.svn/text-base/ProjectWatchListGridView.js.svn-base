/* 
 * 
 * Vishnu C
 */


Ext.define('AFE.view.ProjectWatchListGridView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.projectWatchListGridView',
    width:'100%',
    initComponent: function() {
        this.layout={
            type: 'vbox',    
            align: 'stretch'
        };
        this.items =[
        {
            flex:20,
            padding: 7,
            border:false,
            layout:{
                type: 'vbox',    
                align: 'stretch'
            },
            items:[{
                xtype:'grid',
                width:'100%',
                frame: true,
                columnLines:true,
                border:false,
                cls:'topAFEClassesGrid',
                id:'projectWatchListGrid',
              
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
                    text: 'Accruals',
                    id:'fieldEstimateColumn',
                    dataIndex: 'FieldEstimate',
                    flex:1
                },
                 {
                    text: 'Total',
                    id:'TotalColumn',
                    dataIndex: 'Total',
                    flex:1
                },
                {
                    text: '%Consumption',
                     id:'consumptionColumn',
                    dataIndex: 'FieldEstimatePercent',
                    flex:1
                    
                }
                ],
                width: '100%',
             flex:1
            }]
        },
        
        {
            flex:2,
            xtype:'panel',
            layout:{
                type:'hbox',
                pack:'end'
            },
            items:[
            {
                xtype:'panel',
                flex:1,
                border:false
            },
               
            {
             
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
                 
                  
                    
                    xtype:'panel',
                    html:'Show Map',
                    action:'ShowMap',
                    border:false, 
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
            border:false
            
        }];
        this.flex=1;
            
        this.callParent(arguments);
    }
});