/* 
 * Nirmal Kumar K S
 */

Ext.define('AFE.model.AFEModel', {
    extend: 'Ext.data.Model',
    fields: [
    {
        name: 'AFEID',
        type: 'string'
    },
    {
        name: 'Name',
        type: 'string'
    },
    {
        name: 'AFENumber',
        type: 'string'
    },
    {
        name: 'Status',
        type: 'string'
    },
    {
        name: 'FromDate',
        type: 'date'
    },
    {
        name: 'EndDate',
        type: 'date'
    },
    {
        name: 'Budget',
        type: 'double'
    },
    {
        name: 'FieldEstimate',
        type: 'double'
    },
    {
        name: 'FieldEstimatePercent',
        type: 'double'
    },
    {
        name: 'FieldEstimateAsStr',
        type: 'string'
    },
    {
        name: 'Actual',
        type: 'double'
    },
    {
        name: 'ActualPercent',
        type: 'double'
    },
    {
        name: 'ActualAsStr',
        type: 'string'
    },
    {
        name: 'Total',
        type: 'double'
    }
    ]
});
