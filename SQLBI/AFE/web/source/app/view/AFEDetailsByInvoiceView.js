/*
 * Merrin J
 */


Ext.define('AFE.view.AFEDetailsByInvoiceView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.afeDetailsByInvoiceView',

    initComponent: function() {
        this.layout={
            type: 'vbox'
        };
        this.items=[
       
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
                layout:{
                    type:'hbox'
                },
                items:[{
                    flex:1,
                    bodyStyle:'background:transparent;color:white',
                    border:false
                },
                {
                    xtype:'label' ,
                    text:'AFE Details',
                    id:'AfeHeaderTextInvoice',
                    flex:6
                },
                  {
                        xtype:'label' ,
                        text:'1/1/2012 - 6/30/2012',
                        
                        cls:'titleDate',
                        flex:18
                    }
                ],
                flex:1,
                border:false,
                bodyStyle:'background:transparent;color:white'
            }


            ]
        },
        {
           
            bodyStyle:'border-color:#000',
            flex:8,
            width:'100%',
            layout: {
                type: 'vbox',
                align:'stretch'
            },
            items:[
            {
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
                        text:'Shelton A 4',
                        flex:1,
                        baseCls:'headlineMetricsData'
                    },
                    {
                        xtype:'label',
                        text:'Name ',
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
                        text:'Drilling',
                        cls:'headlineMetricsData',
                        flex:1
                    },
                    {
                        xtype:'label',
                        text:'Class',
                        cls:'headlineMetricsLabel',
                        flex:2
                    }
                    ]
                },
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

                        style:'font-weight:bold;',
                        flex:1,
                        xtype:'label',
                        cls:'headlineMetricsData',
                        html:'$256.45MM'
                    },
                    {
                        xtype:'label',
                        text:'AFE Estimate',
                        cls:'headlineMetricsLabel',
                        flex:2
                    }
                    ]
                },
                
                {
                    flex:1,
                    border:false,
                    layout:{
                        type: 'vbox',
                        align:'center'
                    //                        pack:'start'
                    },
                    items:[{

                        style:'font-weight:bold;',
                        flex:1,
                        xtype:'label',
                        cls:'headlineMetricsData',
                        html:'$56.45MM'
                    },
                    {
                        xtype:'label',
                        text:'Actuals',
                        cls:'headlineMetricsLabel',
                        flex:2
                    }
                    ]
                },
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
                        html:'50.10MM ',
                        cls:'headlineMetricsData',
                        flex:1

                    },
                    {
                        xtype:'label',
                        text:'Total Accruals',
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
                        html:'<div>$106.55MM <span style="color:green">(30%)*</span></div>',
                        cls:'headlineMetricsData',
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
                flex:3,
                border:false,
                layout:{
                    type: 'vbox',
                    align:'center',
                    pack:'start'
                },
                items:[{
                    xtype:'label',
                    text:'D&C Single Lateral',
                    cls:'headlineMetricsData',
                    flex:1
                },{
                    xtype:'label',
                    text:'AFE Desc',
                    cls:'headlineMetricsLabel',
                    flex:2
                }]
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




