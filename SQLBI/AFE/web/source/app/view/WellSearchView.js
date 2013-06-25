/* 
 * 
 * Vishnu C
 */


Ext.define('AFE.view.WellSearchView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.wellSearchView',

    initComponent: function() {
        this.items =[{
            layout:'vbox',
            height:'auto',
            border:false,
            style:'margin-left:10px;margin-top:40px',
            items:
            [{
                xtype: 'textfield',
                id:'completionName',
                labelAlign: 'top',
                fieldLabel: 'Well Completion Name',
                width: 168,
                margins:'5 0 20 0'
            },
            {
                xtype: 'combobox',
                id:'status',
                labelAlign: 'top',
                name: 'text',
                fieldLabel: 'Status',
                width: 130,
                margins:'5 0 20 0'
            },
            {
                xtype: 'datefield',
                id:'beginDate',
                labelAlign: 'top',
                fieldLabel: 'Begin Date',
                width: 130,
                margins:'5 0 20 0'
            },
            {
                xtype: 'datefield',
                id:'endDate', 
                labelAlign: 'top',
                fieldLabel: 'End Date',
                width: 130,
                margins:'5 0 25 0'
            },
            {
                xtype:'button',
                action:'wellSearch',
                text:'Search',
                cls:'searchButton',
                width:100
            }
            ]
        }]
        this.callParent(arguments);
    }
});