/* 
 * 
 * Vishnu C
 */



Ext.define('AFE.view.AFESearchView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.afeSearchView',

    initComponent: function() {
        this.items=[{
            xtype:'panel',
            layout:'vbox',
            padding:'90 0 0 10',
            width:'100%',
            border:false,
            items:[
            {
                xtype:'label',
                html:'<p style="font-family:Arial;font-size:12px;">AFE Number</p>',
                margins:'0 0 5 0'
            },
            {
                xtype:'combo',
                id:'afenumber',
                width:180,
                displayField: 'AFENumber',
                valueField:'AFENumber',
                store: 'AFEsByClassStore',
                queryMode: 'local',
                minChars:1,
                hideTrigger:true,
                forceSelection:true,
                typeAhead:true,
                width:180

            },
            {
                xtype:'label',
                html:'<p style="font-family:Arial;font-size:12px;">Or</p>',
                margins:'18 0 18 80'
            },
            {
                xtype:'label',
                html:'<p style="font-family:Arial;font-size:12px;">AFE Name</p>',
                margins:'0 0 5 0'
            },
            {
                id:'afename',
                xtype:'combo',
                displayField: 'Name',
                valueField:'Name',
                store: 'AFEsByClassStore',
                queryMode: 'local',
                minChars:1,
                hideTrigger:true,
                forceSelection:true,
                typeAhead:true,
                width:180
            },
            {
                xtype:'button',
                width:100,
                text:'Search',
                action:'AFESearch',
                cls:'searchButton',
                margins:'70 0 0 0'
            }]

        }]

        
        this.callParent(arguments);
    }
});