/* 
 * 
 * Merrin J
 */



Ext.define('AFE.view.HeadlineMetricsView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.headlineMetricsView',

    initComponent: function() {
        this.layout={
            type: 'vbox'
        };
        this.items=[
        {
            id:'HeadlineMetricsHeader',
           
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
                    type:'hbox',
                     align: 'middle'
                },
                items:[ 
                {
                    id:'blankspaceHeadlineMetrics',
                    flex:1,
                    bodyStyle:'background:transparent;color:white',
                                    border:false
                },
                {
                    xtype:'panel',
                    bodyStyle:'background:transparent;color:white',
                    layout:{
                        type:'hbox',
                        align: 'middle'
                    },
                    flex:5,
                    items:[{
                        xtype:'label' ,
                        text:'Headline Metrics'
                    
                    }],
                  border:false
                }
                ,
                {
                    xtype:'panel',
                    bodyStyle:'background:transparent;color:white',
                    layout:{
                        type:'hbox',
                        align: 'middle'
                    },
                    flex:14,
                    items:[{
                        xtype:'label' ,
                        text:'1/1/2012 - 6/30/2012',
                        
                        cls:'titleDate'
                    }],
                  border:false
                },
                

                ],
                flex:1,
                                border:false,
                bodyStyle:'background:transparent;color:white'
            }
            
           
            ]
        },
        {
            id:'HeadlineMetricsContent',
            bodyStyle:'border-color:#000',
            flex:8,
            width:'100%',
            layout: {
                type: 'vbox',
                align:'stretch'
            },            
            items:[
            {
                id:'blankSpace',
                flex:1,
                border:false
            },
            {
                flex:3,
                border:false,
                layout:{
                    type: 'hbox',
                    align:'stretch'
                },
                items:[
                {      
                    flex:1,
                    border:false,
                    layout:{
                        type: 'vbox',
                        align:'center',
                        pack:'start'
                    },               
                    items:[{
                        xtype:'label',
                        text:'400',
                        id:'headLineMetrcsNoOfAFE',
                        flex:1,
                        baseCls:'headlineMetricsData'
                    },
                    {
                        xtype:'label',
                        text:'Number of AFEs ',
                        flex:2,
                        cls:'headlineMetricsLabel'
                    }
                    ]
                },
                {
                    flex:1,
                    border:false,
                    layout:{
                        type: 'vbox',
                        align:'center',
                        pack:'start'
                    },
                    items:[{
                        xtype:'label',
                        id:'headLineMetrcsTotalAfeEstimate',
                        text:'$246.45MM',
                        cls:'headlineMetricsData',
                        flex:1
                    },
                    {
                        xtype:'label',
                        text:'Total AFE Estimate',
                        cls:'headlineMetricsLabel',
                        flex:2
                    }
                    ]
                }
                ]
            },
            {
                flex:3,
                border:false,
                layout:{
                    type: 'hbox',
                    align:'stretch'
                },
                items:[
                {
                    flex:1,
                    border:false,
                    layout:{
                        type: 'vbox',
                        align:'center',
                        pack:'start'
                    },
                    items:[{
                        xtype:'label',
                        html:'<div>$256.45MM <span style="color:red">(130%)*</span></div>',
                        cls:'headlineMetricsData',
                        id:'headLineMetrcsTotalAccruals',
                        flex:1
                    },
                    {
                        xtype:'label',
                        flex:2,
                        text:'Total Accruals',
                        cls:'headlineMetricsLabel'
                    }
                    ]
                },
                {
                    flex:1,
                    border:false,
                    layout:{
                        type: 'vbox',
                        align:'center'
                    },
                    items:[{
                       
                        style:'font-weight:bold;',
                        flex:1,
                        xtype:'label',
                        cls:'headlineMetricsData',
                        id:'headLineMetrcsActuals',
                        html:'<div>$56.45MM <span style="color:green">(30%)*</span></div>'
                        
                    },
                    {
                        xtype:'label',
                        text:'Actuals',
                        cls:'headlineMetricsLabel',
                        flex:2
                    }
                    ]
                }
                ]
            },
            {
                flex:3,
                border:false,
                layout:{
                    type: 'hbox',
                    align:'stretch'
                },
                items:[
                {
                    flex:1,
                    border:false,
                    layout:{
                        type: 'vbox',
                        align:'center',
                        pack:'start'
                    },
                    items:[{
                        xtype:'label',
                        text:'30',
                        cls:'headlineMetricsData',
                        id:'headLineMetrcsAvgDurationOfAfe',
                        flex:1

                    },
                    {
                        xtype:'label',
                        text:'Avg Duration of AFE(Days)',
                        cls:'headlineMetricsLabel',
                        flex:2
                    }]
                },
                {
                    flex:1,
                    border:false,
                    layout:{
                        type: 'vbox',
                        align:'center',
                        pack:'start'
                    },
                    items:[{
                        xtype:'label',
                        text:'$301M',
                        cls:'headlineMetricsData',
                        id:'headLineMetrcsSumOfActualsAndAccruals',
                        flex:1
                    },
                    {
                        xtype:'label',
                        text:'Actuals + Accruals',
                        cls:'headlineMetricsLabel',
                        flex:2
                    }
                    ]
                }
                ]
            },      
            {  
                flex:1,
                border:false,
                width:'100%',
                layout:{
                    type: 'hbox',
                    align:'strech',
                    pack:'start'
                },
                items:[ {
                    xtype:'label',
                    text:'',
                    flex:3
                },
                {
                    xtype:'label',
                    html:'<div style="font-size:10px">*Percentages are calculated against budget</div>',
                    flex:2
                }
                ]
            }
            ]            
        }];
        this.callParent(arguments);
    }
});