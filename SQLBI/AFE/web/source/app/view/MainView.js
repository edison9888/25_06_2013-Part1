/* 
 *
 * Vishnu C
 */
Ext.define('AFE.view.MainView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.mainView',

    initComponent: function() {
       
        this. layout={
                type: 'ux.center'
               
             };
         
        this.items=[     
        Ext.create('Ext.panel.Panel', {
            id:'mainContainer',
            width: '95%',
            height: '120%',
           
            layout:{
                type:'border',
                align:'strech'
                
            },
            items: [{

                region: 'north',     // position for region
                xtype: 'headerView',
                height: 75,
                //                split: true,         // enable resizing
                margins: '0 0 2 0'
            },{
               
                region:'west',
                xtype: 'leftView',
                margins: '0 0 0 0',
                width: 200,
                height: 100,
                
                collapsible: false,
                animCollapse: true,
               
                layout: 'accordion'
                
               
                
            },{
                region: 'center',     // center region is required, no width/height specified
                xtype: 'contentContainerView',
                layout: 'fit',
                height: 100,
                margins: '0 0 0 0'
            }]   
                  
        })
               
           
        ];
        this.callParent(arguments);
    }
});

