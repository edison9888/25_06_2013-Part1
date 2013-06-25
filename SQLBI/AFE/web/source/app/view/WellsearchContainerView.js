/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
Ext.define('AFE.view.WellsearchContainerView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.wellsearchContainerView',

    initComponent: function() {
        this.layout={
            type: 'vbox'
        };
        this.items=[
        {
            
            flex:2,
            margin:'5 5 5 5',
            border:false,
            width:'100%',
            layout:{
                type: 'fit'
            },
            items:[{
               xtype: 'wellInformationView'
            }]
        },{

            flex:3,
            margin:'5 5 5 5',
            border:false,
            width:'100%',
            layout:{
                type: 'fit'
            },
            items:[
            {
                xtype:'wellSearchAFEsDetails'
            }
            ]

        }
        ];
        this.callParent(arguments);
    }
});

