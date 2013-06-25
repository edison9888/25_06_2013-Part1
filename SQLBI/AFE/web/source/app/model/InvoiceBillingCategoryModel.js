/* 
 * Merrin J
 */

Ext.define('AFE.model.InvoiceBillingCategoryModel', {
    extend: 'Ext.data.Model',
    fields: [
    {
        name: 'Actual',
        type:'double'
    },
    {
        name:'ActualsAsStr',
        type:'String'
    },
    {
        name:'BillingCategoryID',
        type:'String'
    },
    {
        name:'BillingCategoryName',
        type:'String'
    },
    {
        name:'FieldEstimate',
        type:'double'
    },
    {
        name:'FieldEstimateAsStr',
        type:'String'
    },
    {
        name:'InvoiceCount',
        type:'int'
    }

    ]
});

