/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

Ext.define('AFE.controller.ChartController', {
    extend: 'Ext.app.Controller',

    views: [
    'HeatChart'
    ],
    stores: [
        'ChartData'
    ],
    init: function() {
        console.log('Initialized Users! This happens before the Application launch function is called');
    }
});