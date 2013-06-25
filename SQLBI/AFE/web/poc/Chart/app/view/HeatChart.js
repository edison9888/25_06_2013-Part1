

Ext.define("AFE.view.HeatChart", 
{
    extend : 'Ext.panel.Panel',
    alias: 'widget.heatChart',
    width:500,
    height:300,
   
    initComponent: function() {
       
       
       
        this.layout=[{
            type: 'vbox',       // Arrange child items vertically
            align: 'stretch',    // Each takes up full width
            padding: 5 
        }];
        this.items=[
        Ext.create('Ext.panel.Panel', {
            id:'center-container',
            height:300,
            width:500,
            layout:[{
                type: 'vbox',       // Arrange child items vertically
                align: 'stretch',    // Each takes up full width
                padding: 5 
            }],
            items:[Ext.create('Ext.panel.Panel', {
                id:'infovis',
                height:300,
                width:500
                  
            })],
            buttons:[ Ext.create('Ext.Button', {
                text: 'Click me',
               
                handler: function() {
                   
                    var docElm = document.documentElement;
                    if (docElm.requestFullscreen) {
                        docElm.requestFullscreen();
                    }
                    else if (docElm.mozRequestFullScreen) {
                        docElm.mozRequestFullScreen();
                    }
                    else if (docElm.webkitRequestFullScreen) {
                        docElm.webkitRequestFullScreen();
                    }
                }
            })]
        
                  
        })
       
              
        ];

        this.callParent(arguments);
        
    }
	
	
});