//
//  test.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 12/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum RVAPIRequestType
{
    RVAPIRequestTypeGetUserInfo=1,
    RVAPIRequestTypeGetOrganizationTypes,
    RVAPIRequestTypeGetOrganizations,
    RVAPIRequestTypeGetHeadlineMetric,
    RVAPIRequestTypeGetAFEClass,
    RVAPIRequestTypeGetAFEs,    
    RVAPIRequestTypeGetAFEsByClass,        
    RVAPIRequestTypeGetWellNames,
    RVAPIRequestTypeGetWellDetails,
    RVAPIRequestTypeGetAfe,
    RVAPIRequestTypeGetAllAFEs,
    RVAPIRequestTypeGetAfeDetails,
    RVAPIRequestTypeGetBurnDownItems,
    RVAPIRequestTypeGetBillingCategories,
    RVAPIRequestTypeGetAfeInvoice,
    RVAPIRequestTypeGetStatusTypes    
        
} RVAPIRequestType;

typedef enum RVAPIResponseStatusCode
{
    RVAPIResponseStatusCodeWrongRequestURLError = -400,
    RVAPIResponseStatusCodeNoConnectivityError = -500,
    RVAPIResponseStatusCodeRequestCanceled = -900,
    RVAPIResponseStatusCodeGenericServerError = -250,    
    RVAPIResponseStatusCodeSuccessful = -200,
    RVAPIResponseStatusCodeServerUnReachableError = -300,
    
}RVAPIResponseStatusCode;



@interface RVAPIConstants : NSObject
{
    
}
+ (NSString *)urlEncodedParamStringFromString:(NSString *)original;

@end
