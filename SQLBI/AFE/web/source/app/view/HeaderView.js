/* 
 * 
 * Vishnu C
 */


Ext.define('AFE.view.HeaderView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.headerView',

    initComponent: function() {
     
        this.items=[{
                xtype:'panel',
                layout:'hbox',
                border:false,
                padding:'3',
                items:[{
                        xtype:'panel',
                        width:68,
                        height:66,
                        bodyStyle:'background:#FFCC00',
                        layout:'vbox',
                        items:[
                            {
                                margins:'4 0 0 3',
                                xtype:'label',
                                cls:'linn',
                                text:'LINN'
                            },
                            {
                                margins:'0 0 0 3',
                                xtype:'label',
                                cls:'energy',
                                text:'Energy'
                            }]
                    },
                    {
                        xtype:'label',
                        cls:'datawarehouse',
                        text:'Data Warehouse- AFE Dashboard',
                        margin:'24 0 0 5'
                    },{
                        xtype:'label',
                        text:'',
                        flex:22
                    },
                    {
                        xtype:'panel',
                        html:'My AFE Settings',
                        action:'AFESettingsAction',
                        flex:3,
                        margin:'50 0 0 0',
                        cls:'afeSettings',
                        border:false,
                        listeners : {
                            render : function(c) {
                                c.getEl().on('click', function(){
                                    this.fireEvent('click', c);//fire the click event of panel
                                }, c);
                            }
                        }
                    }
                ]
            }]
        this.callParent(arguments);
    }
});