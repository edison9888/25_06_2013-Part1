/* 
 * 
 * Vishnu C
 */

Ext.define('AFE.view.ProjectWatchListView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.projectWatchListView',

    initComponent: function() {
        this.layout={
            type: 'vbox'
        };
        this. items= [
        {
            id:'projectWatchListHeader',
           
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
                layout:{
                    type:'hbox'
                },
                items:[{
                    id:'blankspacePr',
                    flex:1,
                    
                    border:false
                },
                {
                    xtype:'label' ,
                 
                    
                    text:'Project Watch List',
                    flex:10
                }
                ],
                flex:1,
                border:false,
                bodyStyle:'background:transparent;color:white'
            },
             {
                    xtype:'label' ,
                 
                    
                    text:'1/1/2012 - 6/30/2012',
                    flex:2,
                    cls:'titleDate'
                }
            /*,
              {
                xtype: 'radiogroup',
                action: 'topProjectWatchLIstRadio',
                columns: [50, 50],
                id:'projectWatchListRadio',
                // Arrange radio buttons into two columns, distributed vertically
                columns: 2,
                vertical: true,
                flex: 4,
                items: [{
                    xtype: 'radiofield',
                    name: 'radioProjectWatchList',
                    inputValue: 'FieldEstimate',
                    action: 'sortProjectWatchListBudget',
                    style:'color:white;',
                    boxLabel: 'Field Estimate',
                    checked: true,
                    flex:1
                },
                {
                    xtype: 'radiofield',
                    name: 'radioProjectWatchList',
                    inputValue: 'Actuals',
                    action: 'sortProjectWatchListAFECount',
                    style:'color:white',
                    boxLabel: 'Actuals',
                    flex:1
                }],
             listeners : {
                 change:function(rb, newValue, oldValue, options)
                 {
                     globalObject.getController('ProjectWatchListController').onClickRadioButton(rb, newValue, oldValue, options);
                 }
             }

            }*/
            ]
        },
        {
            id:'projectWatchListContent',
            bodyStyle:'border-color:#000',
            flex:8,
            width:'100%',
            layout:{
                type: 'vbox',     
                align: 'stretch'
            },
            items:[
            {
                xtype:'heatMapView'
                    
            }
            ]
           
            

        }
        ];
        this.callParent(arguments);
    }
});
