/* 
 * Vishnu C
 */


Ext.define('AFE.model.HeadLineMetricsModel', {
    extend: 'Ext.data.Model',
    fields: [
    {
        name:'AFECount',
        type:'int'
    },
    {
        name:'AvgAFEBudget',
        type:'double'
    },
    {
        name:'AvgAFEBudgetASsStr',
        type:'string'
    },
    {
        name:'AvgAFEDuration',
        type:'double'
    },
    {
        name:'TotalActuals',
        type:'double'
    }, 
    {
        name:'TotalActualsAsStr',
        type:'string'
    },
    {
        name:'TotalActualsPercent',
        type:'double'
    },
    {
        name:'TotalBudget',
        type:'double'
    },
    {
        name:'TotalBudgetAsStr',
        type:'string'
    },
    {
        name:'TotalFieldEst',
        type:'double'
    },
    {
        name:'TotalFieldEstAsStr',
        type:'string'
    },
        
    {
        name:'TotalFieldEstPercent',
        type:'double'
    }
    
    ]
});

