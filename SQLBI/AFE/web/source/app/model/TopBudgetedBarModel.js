/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

Ext.define('AFE.model.TopBudgetedBarModel', {
    extend: 'Ext.data.Model',
    fields: [
    {
        name:'AFEID',
        type:'string'
    },
    {
        name:'AFENumber',
        type:'string'
    },
    {
        name:'Actual',
        type:'double'
    },
    {
        name:'ActualAsStr',
        type:'string'
    },
    {
        name:'ActualPercent',
        type:'double'
    },
    {
        name:'Budget',
        type:'double'
    },
    {
        name:'BudgetAsStr',
        type:'string'
    },
    {
        name:'EndDate',
        type:'date'
    },
    {
        name:'EndDateAsStr',
        type:'string'
    },
    {
        name:'FieldEstimate',
        type:'double'
    },
    {
        name:'FieldEstimateAsStr',
        type:'string'
    },

    {
        name:'FieldEstimatePercent',
        type:'double'
    },
    {
        name:'FromDate',
        type:'date'
    },
    {
        name:'FromDateAsStr',
        type:'string'
    },
    {
        name:'Name',
        type:'string'
    },
    {
        name:'Status',
        type:'string'
    },
    {
        name:'Total',
        type:'double'
    }

    ]
});
