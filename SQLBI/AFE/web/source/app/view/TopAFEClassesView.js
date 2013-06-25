/* 
 *
 * Vishnu C
 */


Ext.define('AFE.view.TopAFEClassesView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.topAFEClassesView',

    initComponent: function() {
        this.layout={
            type: 'vbox'     
        };
        this. items= [
        {
            id:'topAFEClassesViewHeader',      
            baseCls:'contentHeader',
            flex:1,
            width:'100%',
            layout: {
                type: 'hbox',
                align: 'middle'
            },
            items:[
            {
                id:'blankspaceTopAFE',
                flex:1,
                border:false,
                bodyStyle:'background:transparent;color:white'
                              
            },
            {
                xtype:'panel',
                layout:{
                    type:'hbox',
                    align: 'middle'
                },
                items:[
                {
                    xtype:'label' ,
                    id: 'topAFEClassesHeaderLabel',
                    text:'Top AFE Classes'               
                }
                ],
                flex:6,
                border:false,
                bodyStyle:'background:transparent;color:white'
            },
            {
                xtype:'panel',
                layout:{
                    type:'hbox',
                    align: 'middle'
                },
                items:[
                {

                    xtype:'label' ,
                 
                    
                    text:'1/1/2012 - 6/30/2012',
                   
                    cls:'titleDate'
                }
                ],
                flex:8,
                border:false,
                bodyStyle:'background:transparent;color:white'
            },
            {
                xtype:'panel',
                id:'topAFEClassesRadioGroupPanel',
                layout:{
                    type:'hbox',
                    align: 'middle'
                },
                items:[
                {
                    xtype: 'radiogroup',
                    id: 'topAFEClassesRadio',
                    columns: [50, 50],
                    // Arrange radio buttons into two columns, distributed vertically
                    columns: 2,
                    vertical: true,
                    flex: 10,
                    items: [{
                        xtype: 'radiofield',
                        name: 'radioTopAFEClasses',
                        inputValue: 'Budget',
                        style:'color:white;',
                        boxLabel: 'Budget',
                        checked: true                    
                    },
                    {
                        xtype: 'radiofield',
                        name: 'radioTopAFEClasses',
                        inputValue: 'AFECount',
                        style:'color:white',
                        boxLabel: 'No.Of AFEs'                   
                    }],
                    listeners : {
                        change:function(rb, newValue, oldValue, options)
                        {
                            globalObject.getController('TopAFEClassesController').onTopAFEClassesToggle(rb, newValue, oldValue, options);
                        }
                    }
                },
                {      
                    flex:1,
                    bodyStyle:'background:transparent;color:white',
                    border:false
                }
                ],
                flex:12,
                border:false,
                bodyStyle:'background:transparent;color:white'
            }        
            ]
        },
        {
            id: 'topAFEClassesViewContent',
            flex:8,
            width:'100%',
            bodyStyle:'border-color:#000',
            layout:{
                type: 'vbox',
                align: 'strech'
            },
            items: [{
                xtype: 'afeClassesSummaryView'
            }]
        }];
        this.callParent(arguments);
    }
});