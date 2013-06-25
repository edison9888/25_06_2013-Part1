/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 * Vivek
 */

Ext.define('AFE.view.MyAFESettingsView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.myAFESettingsView',

    initComponent: function() {
        this.items=[
        {
            padding:'30',

            width:'55%',
            height:600,
            border:false,
            layout:{
                type:'vbox',
                align:'stretch'
            },
            items:[
            {                              
                border:false,
                flex:4,
                layout:{
                    type:'vbox',
                    align:'stretch'
                },
                items:[{
                    xtype:'label',
                    text:'Organization Summary-Parameters',
                    style:"font-weight:bold",
                    flex:2
                },
                {
                    flex:1,
                    border:false
                },
                {
           
                    flex:3,
                    border:false,
                    layout: {
                        type: 'hbox',
                        align:'stretch',
                        pack:'start'
                    },
                    items:[

                    {
                        xtype: 'combobox',
                        fieldLabel: 'Organization',
                        labelWidth:110,
                        labelAlign: 'right',
                        flex:15,
                        border:false
               
                    },
                    {
                        flex:1,
                        border:false
                    },
                    {
                        xtype: 'datefield',                        
                        fieldLabel: 'Begin Date',
                        labelAlign: 'right',
                        flex:15,
                        border:false
                    }
                    ]
                },
                {
                    flex:1,
                    border:false
                },
                {

                    flex:3,
                    border:false,
                    layout: {
                        type: 'hbox',
                        align:'stretch',
                        pack:'start'
                    },
                    items:[
                    {
                        xtype: 'combobox',
                        fieldLabel: 'Organization Name',
                        labelWidth:110,
                        labelAlign: 'right',
                        flex:15,
                        border:false

                    },
                    {
                        flex:1,
                        border:false
                    },
                    {
                        xtype: 'datefield',                        
                        fieldLabel: 'End Date',
                        labelAlign: 'right',
                        flex:15,
                        border:false
                    }
                    ]
                },
                {
                    flex:1,
                    border:false
                },
                {
                    flex:3,
                    border:false,
                    layout: {
                        type: 'hbox',
                        align:'stretch',
                        pack:'start'
                    },
                    items:[
                    {
                        xtype: 'combobox',
                        fieldLabel: 'Status',
                        labelWidth:110,
                        labelAlign: 'right',
                        flex:15,
                        border:false

                    },
                    {
                        flex:1,
                        border:false
                    },
                    {
                        flex:15,
                        border:false
                    }
                    ]
                },
                
                {
                    flex:4,
                    border:false
                }         
                ]
            },         
            {
                
                border:false,
                flex:3,
                layout:{
                    type:'vbox',
                    align:'stretch'
                },
                items:[{
                    xtype:'label',
                    text:'Well Search - Parameters',
                    style:"font-weight:bold",
                    flex:2
                },
                {
                    flex:1,
                    border:false
                },
                {

                    flex:2,
                    border:false,
                    layout: {
                        type: 'hbox',
                        align:'stretch',
                        pack:'start'
                    },
                    items:[

                    {
                        xtype: 'textfield',
                        fieldLabel: 'My Well',                       
                        labelWidth:110,
                        labelAlign: 'right',
                        flex:15,
                        border:false
                    },
                    {
                        flex:1,
                        border:false
                    },
                    {
                        xtype: 'datefield',                       
                        fieldLabel: 'Begin Date',
                        labelAlign: 'right',
                        flex:15,
                        border:false
                    }
                    ]
                },
                {
                    flex:1,
                    border:false
                },
                {

                    flex:2,
                    border:false,
                    layout: {
                        type: 'hbox',
                        align:'stretch',
                        pack:'start'
                    },
                    items:[
                    {
                        xtype: 'combobox',
                        fieldLabel: 'Status',
                        labelWidth:110,
                        labelAlign: 'right',
                        flex:15,
                        border:false
                    },
                    {
                        flex:1,
                        border:false
                    },
                    {
                        xtype: 'datefield',                        
                        fieldLabel: 'End Date',
                        labelAlign: 'right',
                        flex:15,
                        border:false
                    }
                    ]
                },
                {
                    flex:4,
                    border:false
                }


                ]
            },          
            {
               
                border:false,
                flex:3,
                layout:{
                    type:'vbox',
                    align:'stretch'
                },
                items:[{
                    xtype:'label',
                    text:'AFE Search - Parameters',
                    style:"font-weight:bold",
                    flex:2
                },
                {
                    flex:1,
                    border:false
                },
                {

                    flex:2,
                    border:false,
                    layout: {
                        type: 'hbox',
                        align:'stretch',
                        pack:'start'
                    },
                    items:[

                    {
                        xtype: 'textfield',
                        fieldLabel: 'My AFE',
                        labelWidth:110,
                        labelAlign: 'right',
                        flex:15,
                        border:false
                    },
                    {
                        flex:1,
                        border:false
                    },
                    {
                        xtype: 'datefield',                        
                        fieldLabel: 'Begin Date',
                        labelAlign: 'right',
                        flex:15,
                        border:false
                    }
                    ]
                },
                {
                    flex:1,
                    border:false
                },
                {

                    flex:2,
                    border:false,
                    layout: {
                        type: 'hbox',
                        align:'stretch',
                        pack:'start'
                    },
                    items:[
                    {
                        xtype: 'combobox',
                        fieldLabel: 'Status',
                        labelWidth:110,
                        labelAlign: 'right',
                        flex:15,
                        border:false
                    },
                    {
                        flex:1,
                        border:false
                    },
                    {
                        xtype: 'datefield',                        
                        fieldLabel: 'End Date',
                        labelAlign: 'right',
                        flex:15,
                        border:false
                    }
                    ]
                },
                {
                    flex:4,
                    border:false
                }

                ]
            }

       
            ]

        }]
        this.callParent(arguments);
    }
});
