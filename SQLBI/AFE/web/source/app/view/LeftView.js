/* 
 * Vishnu C
 */


Ext.define('AFE.view.LeftView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.leftView',

    initComponent: function() {
        
        this. items= [{
            title: 'Organization Summary',
            xtype:'organizationSummaryView'
        }, {
            title: 'AFE Search',
            xtype:'afeSearchView'
        }, {
            title: 'Well Search',
            xtype:'wellSearchView'
        }];
        this.callParent(arguments);
    }
});