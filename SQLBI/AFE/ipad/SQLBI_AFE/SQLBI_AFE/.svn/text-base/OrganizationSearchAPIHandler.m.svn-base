//
//  OrganizationSearchAPIHandler.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 13/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OrganizationSearchAPIHandler.h"
#import "RvParser.h"

@interface OrganizationSearchAPIHandler ()


-(void) parseJsonToGetOrganizationTypes:(NSString*) responseString forRequest:(RVAPIRequestInfo*) requestInfoObj;
-(void) parseJsonToGetOrganizations:(NSString*) responseString forRequest:(RVAPIRequestInfo*) requestInfoObj;

@end

@implementation OrganizationSearchAPIHandler

NSString * const kOrganizationTypes = @"/OrganizationTypes";
NSString * const kOrganizations = @"/Organizations";
NSString * const kHeadlineMetric = @"/HeadlineMetric";
NSString * const kAFEClass = @"/AFEClass";
NSString * const kAFEsByClass = @"/AFEs";
NSString * const kAFEs = @"/AFEs";

#pragma mark - Constructor

-(RVBaseAPIHandler*) init
{
    self = [super init];
    
    if(self)
    {
        
    }
    return self;
}

- (RVAPIRequestInfo*) getOrganisationTypes
{
    NSString *apiName = kOrganizationTypes;    
    NSString * paramString = @"";
    
    //The below lines of code is important to keep track of the API request.
    RVBaseHttpHandler *objBaseHttpHandler = [[RVBaseHttpHandler alloc] init];
    objBaseHttpHandler.delegate = self;
    RVAPIRequestInfo *objRequestInfo = [[RVAPIRequestInfo alloc] init];
    objRequestInfo.gvAPIHandler = self;
    objRequestInfo.requestType = RVAPIRequestTypeGetOrganizationTypes;
    
    [baseHttpHandlersArray addObject:objBaseHttpHandler];
    [objBaseHttpHandler getRequest:apiName withParamString:paramString withRequestInfo:objRequestInfo];
    
    return objRequestInfo;
    
}

-(RVAPIRequestInfo*) getOrganisationsForOrgType:(NSString*) orgType
{
    NSString *apiName = kOrganizations;    
    NSString * paramString = @"";

    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:orgType]];
    
    //The below lines of code is important to keep track of the API request.
    RVBaseHttpHandler *objBaseHttpHandler = [[RVBaseHttpHandler alloc] init];
    objBaseHttpHandler.delegate = self;
    RVAPIRequestInfo *objRequestInfo = [[RVAPIRequestInfo alloc] init];
    objRequestInfo.gvAPIHandler = self;
    objRequestInfo.requestType = RVAPIRequestTypeGetOrganizations;
    
    [baseHttpHandlersArray addObject:objBaseHttpHandler];
    [objBaseHttpHandler getRequest:apiName withParamString:paramString withRequestInfo:objRequestInfo];
    
    return objRequestInfo;
}


-(RVAPIRequestInfo*) getHeadlineMetricOfOrganisation:(NSString*) orgID withAFEClassID:(NSString*) afeClassID withStatus:(NSString*) status fromStartDate:(NSString*) startDate toEndDate:(NSString*) endDate
{
    NSString *apiName = kHeadlineMetric;    
    NSString * paramString = @"";
    
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:orgID]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:afeClassID]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:startDate]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:endDate]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:status]];

    //The below lines of code is important to keep track of the API request.
    RVBaseHttpHandler *objBaseHttpHandler = [[RVBaseHttpHandler alloc] init];
    objBaseHttpHandler.delegate = self;
    RVAPIRequestInfo *objRequestInfo = [[RVAPIRequestInfo alloc] init];
    objRequestInfo.gvAPIHandler = self;
    objRequestInfo.requestType = RVAPIRequestTypeGetHeadlineMetric;
    
    [baseHttpHandlersArray addObject:objBaseHttpHandler];
    [objBaseHttpHandler getRequest:apiName withParamString:paramString withRequestInfo:objRequestInfo];
    
    return objRequestInfo;

}

-(RVAPIRequestInfo*) getAFEClassesOfOrganisation:(NSString*) orgID withStatus:(NSString*) status fromStartDate:(NSString*) startDate toEndDate:(NSString*) endDate sortedBy:(NSString*) sortByField withSortDirection:(AFESortDirection) sortDirection atPageNumber:(int) pageNumber recordLimitPerPage:(int) limit
{
    NSString *apiName = kAFEClass;    
    NSString * paramString = @"";
    
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:orgID]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:startDate]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:endDate]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:status]];
     paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:sortByField]];
    
    switch (sortDirection) {
        case AFESortDirectionAscending:
        paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:@"ASC"]];
            break;
            
        case AFESortDirectionDescending:
            paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:@"DESC"]];
            break;
            
        default:
            paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:@"DESC"]];
            break;
    }
    
    paramString = [paramString stringByAppendingFormat:@"?Page=%d",pageNumber];
    paramString = [paramString stringByAppendingFormat:@"&limit=%d",limit];
    
    //The below lines of code is important to keep track of the API request.
    RVBaseHttpHandler *objBaseHttpHandler = [[RVBaseHttpHandler alloc] init];
    objBaseHttpHandler.delegate = self;
    RVAPIRequestInfo *objRequestInfo = [[RVAPIRequestInfo alloc] init];
    objRequestInfo.gvAPIHandler = self;
    objRequestInfo.requestType = RVAPIRequestTypeGetAFEClass;
    
    [baseHttpHandlersArray addObject:objBaseHttpHandler];
    [objBaseHttpHandler getRequest:apiName withParamString:paramString withRequestInfo:objRequestInfo];
    
    return objRequestInfo;
    
}


-(RVAPIRequestInfo*) getAFEsOfOrganisation:(NSString*) orgID withAFEClass:(NSString*) afeClassID withStatus:(NSString*) status fromStartDate:(NSString*) startDate toEndDate:(NSString*) endDate sortedBy:(NSString*) sortByField withSortDirection:(AFESortDirection) sortDirection atPageNumber:(int) pageNumber recordLimitPerPage:(int) limit
{
    NSString *apiName;
    NSString * paramString = @"";
    
    if(afeClassID == @"" || afeClassID == @"ALL" || afeClassID == nil)
    {
       apiName  = kAFEs;  
       afeClassID = @"ALL";
    }
    else
    {
        apiName  = kAFEsByClass;    
    }
    
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:orgID]];
    
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:afeClassID]];
    
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:startDate]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:endDate]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:status]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:sortByField]];
    
    switch (sortDirection) {
        case AFESortDirectionAscending:
            paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:@"ASC"]];
            break;
            
        case AFESortDirectionDescending:
            paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:@"DESC"]];
            break;
            
        default:
            paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:@"DESC"]];
            break;
    }
    
    paramString = [paramString stringByAppendingFormat:@"?Page=%d",pageNumber];
    paramString = [paramString stringByAppendingFormat:@"&limit=%d",limit];
    
    //The below lines of code is important to keep track of the API request.
    RVBaseHttpHandler *objBaseHttpHandler = [[RVBaseHttpHandler alloc] init];
    objBaseHttpHandler.delegate = self;
    RVAPIRequestInfo *objRequestInfo = [[RVAPIRequestInfo alloc] init];
    objRequestInfo.gvAPIHandler = self;
    
    if(afeClassID == @"" || afeClassID == @"ALL" || afeClassID == nil)
        objRequestInfo.requestType = RVAPIRequestTypeGetAFEs;
    else
        objRequestInfo.requestType = RVAPIRequestTypeGetAFEsByClass;
    
    [baseHttpHandlersArray addObject:objBaseHttpHandler];
    [objBaseHttpHandler getRequest:apiName withParamString:paramString withRequestInfo:objRequestInfo];
    
    return objRequestInfo;
    
}

-(RVAPIRequestInfo*) getAFEsOfOrganisation:(NSString*) orgID withStatus:(NSString*) status fromStartDate:(NSString*) startDate toEndDate:(NSString*) endDate sortedBy:(NSString*) sortByField withSortDirection:(AFESortDirection) sortDirection atPageNumber:(int) pageNumber recordLimitPerPage:(int) limit
{
    
    return [self getAFEsOfOrganisation:orgID withAFEClass:@"ALL" withStatus:status fromStartDate:startDate toEndDate:endDate sortedBy:sortByField withSortDirection:sortDirection atPageNumber:pageNumber recordLimitPerPage:limit];
    
}


#pragma mark - 

-(void) didReceiveResponseFromServer:(NSString *)responseData forRequest:(RVAPIRequestInfo *)requestInfoObj
{
 
    
    switch (requestInfoObj.requestType) {
        case RVAPIRequestTypeGetOrganizationTypes:
            [self parseJsonToGetOrganizationTypes:responseData forRequest:requestInfoObj];
            break;
        case RVAPIRequestTypeGetOrganizations:
            [self parseJsonToGetOrganizations:responseData forRequest:requestInfoObj];
            break;
            
        case RVAPIRequestTypeGetHeadlineMetric:
            [self parseJsonToGetHeadlineMetrics:responseData forRequest:requestInfoObj];
            break;
            
        case RVAPIRequestTypeGetAFEClass:
            [self parseJsonToGetAFEClasses:responseData forRequest:requestInfoObj];
            break;
            
        case RVAPIRequestTypeGetAFEsByClass:
        case RVAPIRequestTypeGetAFEs:            
            [self parseJsonToGetAFEs:responseData forRequest:requestInfoObj];
            break;
            
        default:
            break;
    }
    
}

-(void) callBackOnParsingCompletionSuccessForRequest:(RVAPIRequestInfo*) requestInfoObj
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(rvAPIRequestCompletedSuccessfullyForRequest:)])
    {
        [self.delegate rvAPIRequestCompletedSuccessfullyForRequest:requestInfoObj];
    }
}

-(void) callBackOnParsingCompletionWithErrorsForRequest:(RVAPIRequestInfo*) requestInfoObj
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(rvAPIRequestCompletedWithErrorForRequest:)])
    {
        [self.delegate rvAPIRequestCompletedWithErrorForRequest:requestInfoObj];
    }
}

#pragma mark - JSON Parsing methods

/*******************************************************************************
 *  Function Name: parseJsonToGetOrganizationTypes:forRequest
 *  Type: Synchronous
 *  Description: Parses the JSON response string for getOrganizationTypes async API request made.
 *  Parametrs:
 *              <responseString>: Response string from the baseHttpHandler.
 *              <requestInfoObj>: Request object associated to the async API call made.
 *  Return Values: requestInfoObj.resultObject will have an array of OrganisationType
 *                 objects in the system
 ********************************************************************************/

-(void) parseJsonToGetOrganizationTypes:(NSString*) responseString forRequest:(RVAPIRequestInfo*) requestInfoObj
{
    
    NSDictionary *data= [responseString JSONValue];
    
    if(self.delegate)
    {
        
        if(!data)
        {
            requestInfoObj.statusCode = RVAPIResponseStatusCodeServerUnReachableError;
            requestInfoObj.statusMessage = @"Cannot Reach Server! Please contact Administrator.";
            requestInfoObj.resultObject = nil;
            
            if([self.delegate respondsToSelector:@selector(rvAPIRequestCompletedWithErrorForRequest:)])
            {
                //[self.delegate rvAPIRequestCompletedWithErrorForRequest:requestInfoObj];
                
                [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionWithErrorsForRequest:) withObject:requestInfoObj waitUntilDone:NO];
            }
            
            return;
        }

        
        RvParser *tempRvParserObj = [[RvParser alloc] init];
        NSArray *parsedArray = [tempRvParserObj mapptoModelClass:@"OrganizationType" :data];
        requestInfoObj.resultObject = parsedArray;
        
        //[self.delegate rvAPIRequestCompletedSuccessfullyForRequest:requestInfoObj];
        
        [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionSuccessForRequest:) withObject:requestInfoObj waitUntilDone:NO];
    }
    
        
}


/*******************************************************************************
 *  Function Name: parseJsonToGetOrganizations:forRequest
 *  Type: Synchronous
 *  Description: Parses the JSON response string for getOrganizations async API request made.
 *  Parametrs:
 *              <responseString>: Response string from the baseHttpHandler.
 *              <requestInfoObj>: Request object associated to the async API call made.
 *  Return Values: requestInfoObj.resultObject will have an array of Organisation
 *                 objects in the system
 ********************************************************************************/

-(void) parseJsonToGetOrganizations:(NSString*) responseString forRequest:(RVAPIRequestInfo*) requestInfoObj
{
    
    NSDictionary *data= [responseString JSONValue];
    
    if(self.delegate)
    {
        if(!data)
        {
            requestInfoObj.statusCode = RVAPIResponseStatusCodeServerUnReachableError;
            requestInfoObj.statusMessage = @"Cannot Reach Server! Please contact Administrator.";
            requestInfoObj.resultObject = nil;
            
            if([self.delegate respondsToSelector:@selector(rvAPIRequestCompletedWithErrorForRequest:)])
            {
                //[self.delegate rvAPIRequestCompletedWithErrorForRequest:requestInfoObj];
                [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionWithErrorsForRequest:) withObject:requestInfoObj waitUntilDone:NO];
            }
            
            return;
        }

        
        RvParser *tempRvParserObj = [[RvParser alloc] init];
        NSArray *parsedArray = [tempRvParserObj mapptoModelClass:@"Organization" :data];
        requestInfoObj.resultObject = parsedArray;
        
        //[self.delegate rvAPIRequestCompletedSuccessfullyForRequest:requestInfoObj];
        
        [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionSuccessForRequest:) withObject:requestInfoObj waitUntilDone:NO];
        
    }
    
}

/*******************************************************************************
 *  Function Name: parseJsonToGetHeadlineMetrics:forRequest
 *  Type: Synchronous
 *  Description: Parses the JSON response string for getHeadlineMetrics async API request made.
 *  Parametrs:
 *              <responseString>: Response string from the baseHttpHandler.
 *              <requestInfoObj>: Request object associated to the async API call made.
 *  Return Values: requestInfoObj.resultObject will one KPModel object in the system
 ********************************************************************************/

-(void) parseJsonToGetHeadlineMetrics:(NSString*) responseString forRequest:(RVAPIRequestInfo*) requestInfoObj
{
    
    NSDictionary *data= [responseString JSONValue];
    
    if(self.delegate)
    {
        if(!data)
        {
            requestInfoObj.statusCode = RVAPIResponseStatusCodeServerUnReachableError;
            requestInfoObj.statusMessage = @"Cannot Reach Server! Please contact Administrator.";
            requestInfoObj.resultObject = nil;
            
            if([self.delegate respondsToSelector:@selector(rvAPIRequestCompletedWithErrorForRequest:)])
            {
                //[self.delegate rvAPIRequestCompletedWithErrorForRequest:requestInfoObj];
                
                [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionWithErrorsForRequest:) withObject:requestInfoObj waitUntilDone:NO];
            }
            
            return;
        }
        
        RvParser *tempRvParserObj = [[RvParser alloc] init];
        NSArray *parsedArray = [tempRvParserObj mapptoModelClass:@"KPIModel" :data];
        requestInfoObj.resultObject = (parsedArray && parsedArray.count>0)? [parsedArray objectAtIndex:0]:nil;
        
        //[self.delegate rvAPIRequestCompletedSuccessfullyForRequest:requestInfoObj];
        
        [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionSuccessForRequest:) withObject:requestInfoObj waitUntilDone:NO];
        
    }
    
}

/*******************************************************************************
 *  Function Name: parseJsonToGetAFEClasses:forRequest
 *  Type: Synchronous
 *  Description: Parses the JSON response string for parseJsonToGetAFEClasses async API request made.
 *  Parametrs:
 *              <responseString>: Response string from the baseHttpHandler.
 *              <requestInfoObj>: Request object associated to the async API call made.
 *  Return Values: requestInfoObj.resultObject will have a dictionary with three keys: 
 *                 "TotPageCount" - Total number of pages, with respect to the limit 
 *                 that was supplied to the API. Object type is NSNumber With int 
 *                 "TotRecordCount" - Total number of AFEClasses in the system.
 *                   Object type is NSNumber With int
 *                 "AFEClassesArray" - An array of AFEClasses objects in the page 
 *                 requested to the API (ie. Page Records)
 ********************************************************************************/

-(void) parseJsonToGetAFEClasses:(NSString*) responseString forRequest:(RVAPIRequestInfo*) requestInfoObj
{
    
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    NSDictionary *data= [responseString JSONValue];
    
    if(self.delegate)
    {
        NSString *errorCode = [data objectForKey:@"ecode"];
        NSString *errorMessage = [data objectForKey:@"msg"];
        
        if(!resultDict)
        {
            requestInfoObj.statusCode = RVAPIResponseStatusCodeServerUnReachableError;
            requestInfoObj.statusMessage = @"Cannot Reach Server! Please contact Administrator.";
            requestInfoObj.resultObject = nil;
            
            if([self.delegate respondsToSelector:@selector(rvAPIRequestCompletedWithErrorForRequest:)])
            {
                //[self.delegate rvAPIRequestCompletedWithErrorForRequest:requestInfoObj];
                
                [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionWithErrorsForRequest:) withObject:requestInfoObj waitUntilDone:NO];
            }
            
            return;
        }
        else if([errorCode isKindOfClass:[NSNull class]] || (errorCode && ![errorCode isEqualToString:@""]))
        {
            requestInfoObj.statusCode = RVAPIResponseStatusCodeGenericServerError;
            requestInfoObj.statusMessage = errorMessage;
            requestInfoObj.resultObject = nil;
            
            if([self.delegate respondsToSelector:@selector(rvAPIRequestCompletedWithErrorForRequest:)])
            {
                //[self.delegate rvAPIRequestCompletedWithErrorForRequest:requestInfoObj];
                
                [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionWithErrorsForRequest:) withObject:requestInfoObj waitUntilDone:NO];
            }
            
            return;
        }
        
        int totPageCount = [[data objectForKey:@"totpgcnt"] intValue];
        int totRecordCount = [[data objectForKey:@"totrcnt"] intValue];
        
        NSArray *pageRecordsArray = [data objectForKey:@"cpgrec"];
        
        RvParser *tempRvParserObj = [[RvParser alloc] init];
        NSArray *parsedArray = [tempRvParserObj mapptoModelClass:@"AFEClass" :pageRecordsArray];
        
        [resultDict setObject:[NSNumber numberWithInt:totPageCount] forKey:@"TotPageCount"];
        [resultDict setObject:[NSNumber numberWithInt:totRecordCount] forKey:@"TotRecordCount"];
        [resultDict setObject:parsedArray? parsedArray:[[NSArray alloc]init] forKey:@"AFEClassesArray"];
        
        requestInfoObj.resultObject = resultDict;
        
        //[self.delegate rvAPIRequestCompletedSuccessfullyForRequest:requestInfoObj];
        
        [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionSuccessForRequest:) withObject:requestInfoObj waitUntilDone:NO];
        
    }
    
}

/*******************************************************************************
 *  Function Name: parseJsonToGetAFEs:forRequest
 *  Type: Synchronous
 *  Description: Parses the JSON response string for parseJsonToGetAFEClasses async API request made.
 *  Parametrs:
 *              <responseString>: Response string from the baseHttpHandler.
 *              <requestInfoObj>: Request object associated to the async API call made.
 *  Return Values: requestInfoObj.resultObject will have a dictionary with three keys: 
 *                 "TotPageCount" - Total number of pages, with respect to the limit 
 *                 that was supplied to the API. Object type is NSNumber With int 
 *                 "TotRecordCount" - Total number of AFEClasses in the system.
 *                   Object type is NSNumber With int
 *                 "AFEsArray" - An array of AFEClasses objects in the page 
 *                 requested to the API (ie. Page Records)
 ********************************************************************************/

-(void) parseJsonToGetAFEs:(NSString*) responseString forRequest:(RVAPIRequestInfo*) requestInfoObj
{
    
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    NSDictionary *data= [responseString JSONValue];
    
    if(self.delegate)
    {
        NSString *errorCode = [data objectForKey:@"ecode"];
        NSString *errorMessage = [data objectForKey:@"msg"];
        
        if(!resultDict)
        {
            requestInfoObj.statusCode = RVAPIResponseStatusCodeServerUnReachableError;
            requestInfoObj.statusMessage = @"Cannot Reach Server! Please contact Administrator.";
            requestInfoObj.resultObject = nil;
            
            if([self.delegate respondsToSelector:@selector(rvAPIRequestCompletedWithErrorForRequest:)])
            {
                //[self.delegate rvAPIRequestCompletedWithErrorForRequest:requestInfoObj];
                
                [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionWithErrorsForRequest:) withObject:requestInfoObj waitUntilDone:NO];
            }
            
            return;
        }
        else if([errorCode isKindOfClass:[NSNull class]] || (errorCode && ![errorCode isEqualToString:@""]))
        {
            requestInfoObj.statusCode = RVAPIResponseStatusCodeGenericServerError;
            requestInfoObj.statusMessage = errorMessage;
            requestInfoObj.resultObject = nil;
            
            if([self.delegate respondsToSelector:@selector(rvAPIRequestCompletedWithErrorForRequest:)])
            {
                //[self.delegate rvAPIRequestCompletedWithErrorForRequest:requestInfoObj];
                
                [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionWithErrorsForRequest:) withObject:requestInfoObj waitUntilDone:NO];
            }
            
            return;
        }
        
        int totPageCount = [[data objectForKey:@"totpgcnt"] intValue];
        int totRecordCount = [[data objectForKey:@"totrcnt"] intValue];
        
        NSArray *pageRecordsArray = [data objectForKey:@"afepgrec"];
        
        RvParser *tempRvParserObj = [[RvParser alloc] init];
        NSArray *parsedArray = [tempRvParserObj mapptoModelClass:@"AFE" :pageRecordsArray];
        
        [resultDict setObject:[NSNumber numberWithInt:totPageCount] forKey:@"TotPageCount"];
        [resultDict setObject:[NSNumber numberWithInt:totRecordCount] forKey:@"TotRecordCount"];
        [resultDict setObject:parsedArray? parsedArray:[[NSArray alloc]init] forKey:@"AFEArray"];
        
        requestInfoObj.resultObject = resultDict;
        
        //[self.delegate rvAPIRequestCompletedSuccessfullyForRequest:requestInfoObj];
        
        [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionSuccessForRequest:) withObject:requestInfoObj waitUntilDone:NO];
        
    }
    
}


@end
