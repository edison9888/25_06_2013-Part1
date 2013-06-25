/* 
 * 
 * Vishnu C
 */

Ext.define('AFE.controller.ContentsViewController', {
    extend: 'Ext.app.Controller',
    views: [
    'ContentsView',
    'ProjectWatchListView'
    ],
    init: function() {
        console.log('Initialized Users! This happens before the Application launch function is called');
    }
});
