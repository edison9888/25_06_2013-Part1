/*
 * Nirmal Kumar K S
 */

Ext.define('AFE.view.AFEClassesView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.afeClassesView',

    initComponent: function() {
        this.layout={
            type: 'vbox',
            align: 'stretch'
        };
        this. items= [
        {
            flex: 1,
            bodyStyle:'border:none;font-size:14px;',
            layout:{
                type: 'hbox',
                pack: 'center',
                align: 'middle'
            },
            items:[
            {
                flex: 1,
                bodyStyle:'border:none;',
                layout:{
                    type: 'hbox',
                    pack: 'end',
                    align: 'middle'
                }
            },
            {
                flex: 3,
                bodyStyle:'border:none;',
                layout:{
                    type: 'hbox',
                    pack: 'center',
                    align: 'middle'
                },
                items:[
                {
                    xtype: 'panel',
                    html: 'Summary',
                    action: 'showAFEClassesSummary',
                    border:false,
                    cls: 'topAFEClassesNavLink',
                    style:'margin: 0 5px 0 0;font-weight: bold;cursor: pointer;',
                    listeners : {
                        render : function(c) {
                            c.getEl().on('click', function(){
                                this.fireEvent('click', c);
                            }, c);
                        }
                    }
                },
                {
                    xtype: 'label',
                    text: '>',
                    style:'margin: 0 5px 0 0;font-size:12px;font-weight: bold;'
                },
                {
                    xtype: 'label',
                    text: 'AFE Classes',
                    style:'margin: 0 5px 0 0;font-size: 14px;margin: 0 5px 0 0;'
                }
               
                ]
            },
            {
                flex: 1,
                bodyStyle:'border:none;',
                layout:{
                    type: 'hbox',
                    pack: 'center',
                    align: 'middle'
                },
                items:[
            
            ]
            }
            
            ]
        },
        {
            bodyStyle:'border:none;',
            flex: 7,
            padding: '0 0 0 0',
            layout:{
                type: 'vbox',
                align: 'strech'
            },
            items:[
            {
                xtype: 'afeClassesGridView'
            }]

        }];
        this.flex =  1;
        this.width =  '100%';
        this.border = false;
        this.callParent(arguments);
    }
});
