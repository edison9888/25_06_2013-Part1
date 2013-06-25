/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


Ext.define('AFE.store.ChartData', {
    extend: 'Ext.data.JsonStore',
     fields: ['name', 'data1', 'data2', 'data3', 'data4', 'data5'],
    data: [
        { 'name': 'metric one',   'data1':100, 'data2':0, 'data3':0, 'data4':0,  'data5':0 },
        { 'name': 'metric two',   'data1':100,  'data2':8,  'data3':16, 'data4':10, 'data5':3  },
        { 'name': 'metric three', 'data1':5,  'data2':2,  'data3':14, 'data4':12, 'data5':7  },
        { 'name': 'metric four',  'data1':2,  'data2':14, 'data3':6,  'data4':1,  'data5':23 },
        { 'name': 'metric five',  'data1':27, 'data2':38, 'data3':36, 'data4':13, 'data5':33 }
    ]
});