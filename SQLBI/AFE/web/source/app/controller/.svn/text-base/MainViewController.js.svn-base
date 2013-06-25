/* 
 * Vishnu C
 */

Ext.define('AFE.controller.MainViewController', {
    extend: 'Ext.app.Controller',
    views: [
    'MainView',
    'HeaderView',
    'LeftView',
    'ContentContainerView',
    'MyAFESettingsContainerView',
    'MyAFESettingsView'
    ],
    init: function() {
        console.log('Initialized Users! This happens before the Application launch function is called');
        this.control(
        {
            'headerView panel[action=AFESettingsAction]': {
                click:this.onMyAFESettingsClik
            }
        }
    )
    },
    onMyAFESettingsClik: function(){
    
      var component=Ext.getCmp('contentContainer');
        if(component.items.length>0){
            component.remove(component.items.first(), true);
        }
        component.add(0,{
            xtype:'myAFESettingsContainerView',
            layout: 'fit',
            border: false,
            region: 'center',
            margins: '0 0 0 0'
        });
        component.doLayout();
    }
});
