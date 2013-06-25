/* 
 * 
 * Vishnu C
 */


Ext.define('AFE.view.OrganizationSummaryView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.organizationSummaryView',

    initComponent: function() {
        this.layout={
            type:'vbox',
            align: 'left'
        };
        this.items=[
        {
            layout:'vbox',
            height:'auto',
            border:false,
            style:'margin-left:10px;margin-top:40px',
       
            items:[
            {
                xtype: 'label',
                forId: 'organizationTypeLabel',
                text: 'Organization:',
                margins: '0 0 0 0'
            },
            {
                xtype:'combobox',
                id:'organizationTypeCombo',
                store: 'OrganizationTypeStore',
                queryMode: 'local',
                displayField: 'DisplayName',
                editable: false,
                allowBlank: false,
                valueField: 'OrgType',
                margins: '5 0 0 0',
                autoSelect:true,
                listeners : {
                    select:function(combo, value)
                    {
                        globalObject.getController('OrganizationSummaryController').onSelectOrganizationType(combo, value);
                    },
                    afterrender: function(combo) {
                        combo.getStore().on("load", function() {
                            var recordSelected = combo.getStore().getAt(0);
                            combo.setValue(recordSelected.get('OrgType'));
                            globalObject.getController('OrganizationSummaryController').onSelectOrganizationType(combo, combo.getValue());
                        });
                                   
                    }
                }

            }
            ,
            {
                xtype: 'label',
                forId: 'organizationNameLabel',
                text: 'Organization Name:',
                margins: '20 0 0 0'
            },
            {
                xtype:'combobox',
                id:'organizationNameCombo',
                store: 'OrganizationNameStore',
                queryMode: 'local',
                displayField: 'OrgName',
                valueField: 'OrgID',
                margins: '5 0 0 0',
                editable: false,
                allowBlank: false,
                autoSelect:true,
                listeners : {
                    afterrender: function(combo) {
                        combo.getStore().on("load", function() {
                            var recordSelected = combo.getStore().getAt(0);
                            combo.setValue(recordSelected.get('OrgName'));
                        });
                                   
                    }
                }
           
            } ,
{
                xtype: 'label',
                forId: 'statusLabel',
                text: 'Status',
                margins: '20 0 0 0'
            },
            {
                xtype:'combobox',
                id:'statusCombo',
                value:'All',
                store: 'StatusStore',
                queryMode: 'local',
                displayField: 'displayField',
                valueField: 'value',
                margins: '5 0 0 0',
                autoSelect:true
           
            } ,
{
                xtype: 'label',
                forId: 'beginDateLabel',
                text: 'Begin Date:',
                margins: '20 0 0 0'
            },
            {
                xtype:'datefield',
                id:'beginDateField',
                anchor: '100%',
                name: 'beginDate',
                format:'Y-m-d',
                 value: new Date(new Date().getUTCFullYear(),0,1),
                maxValue: new Date() 
            },
            {
                xtype: 'label',
                forId: 'endDateLabel',
                text: 'End Date :',
                margins: '20 0 0 0'
            },
            {
                xtype:'datefield',
                id:'endDateField',
                anchor: '100%',
                name: 'endDate',
                 format:'Y-m-d',
                value: new Date(new Date().getUTCFullYear(),new Date().getUTCMonth(),new Date().getUTCDate()-1),
                margins: '5 0 0 0'
           
            },
            {
                xtype: 'button',
                text: 'Search',
                action:'Search',
                cls:'searchButton',
                
                width:80,
                margins: '20 0 0 0'
                
            }
            ]
           
        }
        
        ];
        
        this.callParent(arguments);
    }
});