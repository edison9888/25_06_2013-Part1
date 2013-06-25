/* 
 *
 * Vishnu C
 */


Ext.define('AFE.view.TopBudgetedAFEView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.topBudgetedAFEView',

    initComponent: function() {
        this.layout={
            type: 'vbox'
        };
        this. items= [
         {
            id:'topBudgetedAFEViewHeader',           
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
                flex:1,
                border:false,
                bodyStyle:'background:transparent;color:white',
                layout:{
                    type:'hbox'
                },
                items:[{
                    id:'blankspaceTopBudjet',
                    flex:1,
                    bodyStyle:'background:transparent;color:white',
                    border:false
                },
                {
                    xtype:'label' ,
                    text:'Top Budgeted AFEs',
                    flex:10
                }
                ]
                
           },
           {
                    xtype:'label' ,
                 
                    
                    text:'1/1/2012 - 6/30/2012',
                    flex:2,
                    cls:'titleDate'
                }
//             {
//                xtype: 'radiogroup',
//                id:'topBudgetedAFERadio',
//                columns: [50, 50],
//                // Arrange radio buttons into two columns, distributed vertically
//                columns: 2,
//                vertical: true,
//                flex: 4,
//                items: [{
//                    xtype: 'radiofield',
//                    name: 'radioTopBudgetedAFE',
//                    inputValue: 'FieldEstimate',
////                    action: 'sortTopAFEClassesBudget',
//                    style:'color:white;',
//                    boxLabel: 'Field Estimate',
//                    checked: true,
//                    flex:1
//                },
//                {
//                    xtype: 'radiofield',
//                    name: 'radioTopBudgetedAFE',
//                    inputValue: 'Actuals',
////                    action: 'sortTopAFEClassesAFECount',
//                    style:'color:white',
//                    boxLabel: 'Actuals',
//                    flex:1
//                }]
//
//            }
//         
            ]
        },
       
        {
                id:'topBudgetedAFEViewContent',
                bodyStyle:'border-color:#000',
                flex:8,
                width:'100%',
                layout:{
                 type: 'vbox',
                align: 'stretch'
                },
                items:[{
                   
                    xtype:'barChartContainerView'
                    
                    }
                ]
                }
           ];
        this.callParent(arguments);
    }
});