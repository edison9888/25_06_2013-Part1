/* 
 * Nirmal Kumar K S
 */

Ext.define('AFE.view.AFEClassesSummaryView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.afeClassesSummaryView',

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
                xtype: 'label',
                text: 'Summary',
                style:'margin: 0 5px 0 0;'
            },
            {
                xtype: 'label',
                text: '>',
                style:'margin: 0 5px 0 0;font-size:12px;font-weight: bold;'
            },
            {
                xtype: 'panel',
                html: 'AFE Classes',
                action: 'showAFEClasses',
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
            }
        
            ]
        },
        {
            bodyStyle:'border:none;',
            flex: 7,
            layout:{
                type: 'vbox',
                align: 'left'
            },
            items:[
            {
                xtype: 'pieChartView'
            }
            ]

        }];
        this.flex =  1;
        this.width =  '100%';
        this.border = false;
        this.callParent(arguments);
    }
});
