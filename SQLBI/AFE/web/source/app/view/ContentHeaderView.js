/* 
 * 
 * Vishnu C
 */


Ext.define('AFE.view.ContentHeaderView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.contentHeaderView',
    layout:{
        type:'vbox',
        align:'middle'
    },
    items:[{
        xtype: 'label',
        text:'My AFE Settings',

        cls: 'contentHeaderItem',
        margin: '15 20 0 0',
        listeners : {
            render : function(c) {
                c.getEl().on('click', function(){
                    this.fireEvent('click', c);
                }, c);
            }
        }  
    }
    ],
    baseCls:'menuHeader',
    initComponent: function() {
        this.layout={
            type: 'hbox',
            pack: 'end',
            align: 'stretch'
        };
        this.border=false;
        this.callParent(arguments);
    }
});