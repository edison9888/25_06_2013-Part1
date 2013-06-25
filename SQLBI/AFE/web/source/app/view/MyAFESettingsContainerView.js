/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


Ext.define('AFE.view.MyAFESettingsContainerView',
{
    extend:'Ext.panel.Panel',
    alias:'widget.myAFESettingsContainerView',

    initComponent: function() {
        this.layout={
            type:'vbox',
            align:'stretch'
        },
        this.items=[
        {
            flex:8,
            baseCls:'contentHeader',
            layout:{
                type:'hbox',
                pack:'start',
                align:'middle'
            },
            items:[
            {
                flex:1,
                border:false
            },
            {
                flex:5,
                xtype:'label',
                text:'My AFE Settings',
                style:"font-weight:bold",
                border:false
            },
            {
                flex:30,
                border:false
            }]

        },
        {
            xtype:'myAFESettingsView',
            border:false
        //flex:25
        },
        {
            flex:2,
            border:false
        },
        {
            flex:4,
            border:false,
            layout: {
                type: 'hbox',
                align:'stretch',
                pack:'start'
            },
            items:[
            {
                flex:14,
                border:false
            },
            {
                xtype:'button',
                text:'Save',
                cls:'searchButton',
                flex:2
            },
            {
                flex:1,
                border:false
            },
            {
                xtype:'button',
                text:'Cancel',
                cls:'searchButton',
                flex:2,
                border:false
            },
            {
                flex:3,
                border:false
            }]
        },
        {
            flex:4,
            border:false
        }]

        this.callParent(arguments);
    }
});