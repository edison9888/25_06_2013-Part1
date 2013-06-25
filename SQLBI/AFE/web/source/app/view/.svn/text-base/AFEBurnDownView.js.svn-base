/*
 * Merrin j
 */

Ext.define('AFE.view.AFEBurnDownView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.afeBurnDownView',

    initComponent: function() {
        this.layout={
            type: 'vbox'
   
        };
        this. items= [
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
                    text:' AFE BurnDown',
                    flex:4
                },
                {
                        xtype:'label' ,
                        text:'1/1/2012 - 6/30/2012',
                        
                        cls:'titleDate',
                        flex:15
                    }
                ],
                flex:5,
                border:false,
                bodyStyle:'background:transparent;color:white'
            }
            /*,

            {
                xtype: 'radiogroup',
                columns: [50, 50],
                // Arrange radio buttons into two columns, distributed vertically
                columns: 2,
                vertical: true,
                flex: 4,
                items: [{
                    xtype: 'radiofield',
                    name: 'radioAFEBurnDown',
                    inputValue: 'FieldEstimate',
                    style:'color:white;',
                    boxLabel: 'Field Estimate',
                    checked: true,
                    flex:3
                },
                {
                    xtype: 'radiofield',
                    name: 'radioAFEBurnDown',
                    inputValue: 'Actuals',
                    style:'color:white',
                    boxLabel: 'Actuals',
                    flex:2
                }],
                listeners : {
                    change:function(rb, newValue, oldValue, options)
                    {
                        globalObject.getController('AFESearchController').onAFEBurnDownToggle(rb, newValue, oldValue, options);
                    }
                }
            }*/
            ]
        },
        {
               
            bodyStyle:'border-color:#000',
            flex:8,
            width:'100%',
            layout:{
                type: 'vbox'
            },
            items:[{

                xtype:'burnDownChartView'

            }
            ]
        }
        ];
        this.callParent(arguments);
    }
});

