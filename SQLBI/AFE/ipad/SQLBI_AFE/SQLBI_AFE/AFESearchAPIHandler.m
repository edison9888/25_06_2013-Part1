//
//  AFESearchAPIHandler.m
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 24/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFESearchAPIHandler.h"
#import "RvParser.h"
#import "AFEInvoiceBillingCategory.h"

@implementation AFESearchAPIHandler

NSString * const kGetAllAFEs = @"/AFESearchResult";
NSString * const kGetAFEDetail = @"/AFEDetail";
NSString * const kGetAFEBurnDown = @"/AFEBurnDown";
NSString * const kGetAFEBillingCategory = @"/BillingCategory";
NSString * const kGetAFEInvoice = @"/AFEInvoice";

#pragma mark - Constructor

-(RVBaseAPIHandler*)init{
    self = [super init];
    
    if(self)
    {
        
    }
    return self;
}

-(RVAPIRequestInfo*)getAllAFEs:(NSString *)searchValue withSearchField:(NSString *)nameOrNumber withTopNumberOfRows:(int)topNoOfRows{
    NSString *apiName = kGetAllAFEs;    
    NSString * paramString = @"";
    
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:searchValue]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:nameOrNumber]];
    paramString = [paramString stringByAppendingFormat:@"/%d",topNoOfRows];
    
    //The below lines of code is important to keep track of the API request.
    RVBaseHttpHandler *objBaseHttpHandler = [[RVBaseHttpHandler alloc] init];
    objBaseHttpHandler.delegate = self;
    RVAPIRequestInfo *objRequestInfo = [[RVAPIRequestInfo alloc] init];
    objRequestInfo.gvAPIHandler = self;
    objRequestInfo.requestType = RVAPIRequestTypeGetAllAFEs;
    
    [baseHttpHandlersArray addObject:objBaseHttpHandler];
    [objBaseHttpHandler getRequest:apiName withParamString:paramString withRequestInfo:objRequestInfo];
    return objRequestInfo;
    
}

-(RVAPIRequestInfo*)getAFEDetailsWithID:(NSString *)afeID{
    NSString *apiName = kGetAFEDetail;    
    NSString * paramString = @"";
    
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:afeID]];
    
    //The below lines of code is important to keep track of the API request.
    RVBaseHttpHandler *objBaseHttpHandler = [[RVBaseHttpHandler alloc] init];
    objBaseHttpHandler.delegate = self;
    RVAPIRequestInfo *objRequestInfo = [[RVAPIRequestInfo alloc] init];
    objRequestInfo.gvAPIHandler = self;
    objRequestInfo.requestType = RVAPIRequestTypeGetAfeDetails;
    
    [baseHttpHandlersArray addObject:objBaseHttpHandler];
    [objBaseHttpHandler getRequest:apiName withParamString:paramString withRequestInfo:objRequestInfo];
    return objRequestInfo;
}

-(RVAPIRequestInfo*)getAFEBurnDownWithID:(NSString *)afeID {
    NSString *apiName = kGetAFEBurnDown;    
    NSString * paramString = @"";
    
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:afeID]];
    
    //The below lines of code is important to keep track of the API request.
    RVBaseHttpHandler *objBaseHttpHandler = [[RVBaseHttpHandler alloc] init];
    objBaseHttpHandler.delegate = self;
    RVAPIRequestInfo *objRequestInfo = [[RVAPIRequestInfo alloc] init];
    objRequestInfo.gvAPIHandler = self;
    objRequestInfo.requestType = RVAPIRequestTypeGetBurnDownItems;
    
    [baseHttpHandlersArray addObject:objBaseHttpHandler];
    [objBaseHttpHandler getRequest:apiName withParamString:paramString withRequestInfo:objRequestInfo];
    return objRequestInfo;
}

-(RVAPIRequestInfo*)getAFEBillingCategoryWithID:(NSString *)afeID andSortBy:(NSString *)sortBy withSortOrder:(NSString *) sortingOrder withPageNumber:(int) pageNumber andLimit:(int) limit{
    NSString *apiName = kGetAFEBillingCategory;    
    NSString * paramString = @"";
    
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:afeID]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:sortBy]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:sortingOrder]];
    paramString = [paramString stringByAppendingFormat:@"?page=%d",pageNumber];
    paramString = [paramString stringByAppendingFormat:@"&limit=%d",limit];
    
    //The below lines of code is important to keep track of the API request.
    RVBaseHttpHandler *objBaseHttpHandler = [[RVBaseHttpHandler alloc] init];
    objBaseHttpHandler.delegate = self;
    RVAPIRequestInfo *objRequestInfo = [[RVAPIRequestInfo alloc] init];
    objRequestInfo.gvAPIHandler = self;
    objRequestInfo.requestType = RVAPIRequestTypeGetBillingCategories;
    
    [baseHttpHandlersArray addObject:objBaseHttpHandler];
    [objBaseHttpHandler getRequest:apiName withParamString:paramString withRequestInfo:objRequestInfo];
    return objRequestInfo;
}

-(RVAPIRequestInfo*)getAFEInvoiceWithBillingCategoryID:(NSString *)billingCategoryID andWithAFEID:(NSString *)afeID andSortBy:(NSString *)sortBy withSortOrder:(NSString *) sortingOrder withPageNumber:(int) pageNumber andLimit:(int) limit{
    
    NSString *apiName = kGetAFEInvoice;    
    NSString * paramString = @"";
    
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:billingCategoryID]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:afeID]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:sortBy]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:sortingOrder]];
    paramString = [paramString stringByAppendingFormat:@"?page=%d",pageNumber];
    paramString = [paramString stringByAppendingFormat:@"&limit=%d",limit];
    
    //The below lines of code is important to keep track of the API request.
    RVBaseHttpHandler *objBaseHttpHandler = [[RVBaseHttpHandler alloc] init];
    objBaseHttpHandler.delegate = self;
    RVAPIRequestInfo *objRequestInfo = [[RVAPIRequestInfo alloc] init];
    objRequestInfo.gvAPIHandler = self;
    objRequestInfo.requestType = RVAPIRequestTypeGetAfeInvoice;
    
    [baseHttpHandlersArray addObject:objBaseHttpHandler];
    [objBaseHttpHandler getRequest:apiName withParamString:paramString withRequestInfo:objRequestInfo];
    return objRequestInfo;
}

#pragma mark - Received Response
-(void)didReceiveResponseFromServer:(NSString *)responseData forRequest:(RVAPIRequestInfo *)requestInfoObj{
    switch (requestInfoObj.requestType) 
    {
        case RVAPIRequestTypeGetAllAFEs:
            [self parseJsonToGetAllAFEs:responseData forRequest:requestInfoObj];
            break;
            
        case RVAPIRequestTypeGetAfeDetails:
            [self parseJsonToGetAFEDetails:responseData forRequest:requestInfoObj];
            break;
            
        case RVAPIRequestTypeGetBurnDownItems:
            [self parseJsonToGetAFEBurnDownItems:responseData forRequest:requestInfoObj];
            break;
            
        case RVAPIRequestTypeGetBillingCategories:
            [self parseJsonToGetAFEBillingCategories:responseData forRequest:requestInfoObj];
            break;
            
        case RVAPIRequestTypeGetAfeInvoice:
            [self parseJsonToGetAFEInvoice:responseData forRequest:requestInfoObj];
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
 *  Function Name: parseJsonToGetAllAFEs:forRequest
 *  Type: Synchronous
 *  Description: Parses the JSON response string for AFE Search calls async API request made.
 *  Parametrs:
 *              <responseString>: Response string from the baseHttpHandler.
 *              <requestInfoObj>: Request object associated to the async API call made.
 *  Return Values: requestInfoObj.resultObject will have an array of AllAFEs
 *                 objects in the system
 ********************************************************************************/

-(void) parseJsonToGetAllAFEs:(NSString*) responseString forRequest:(RVAPIRequestInfo*) requestInfoObj{
    
    NSDictionary *data= [responseString JSONValue];
    
    if(self.delegate)
    {
        RvParser *tempRvParserObj = [[RvParser alloc] init];
        NSArray *parsedArray = [tempRvParserObj mapptoModelClass:@"AllAFEs":data];
        requestInfoObj.resultObject = parsedArray;
        
        //[self.delegate rvAPIRequestCompletedSuccessfullyForRequest:requestInfoObj];
        
        [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionSuccessForRequest:) withObject:requestInfoObj waitUntilDone:NO];
    }
}

-(void) parseJsonToGetAFEDetails:(NSString*) responseString forRequest:(RVAPIRequestInfo*) requestInfoObj{
    
    NSDictionary *data= [responseString JSONValue];
    
    if(self.delegate)
    {
        RvParser *tempRvParserObj = [[RvParser alloc] init];
        NSArray *parsedArray = [tempRvParserObj mapptoModelClass:@"AFE":data];
        requestInfoObj.resultObject = parsedArray;
        
        //[self.delegate rvAPIRequestCompletedSuccessfullyForRequest:requestInfoObj];
        
        [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionSuccessForRequest:) withObject:requestInfoObj waitUntilDone:NO];
    }
}

-(void) parseJsonToGetAFEBurnDownItems:(NSString*) responseString forRequest:(RVAPIRequestInfo*) requestInfoObj{
    
    NSDictionary *data= [responseString JSONValue];
    
    if(self.delegate)
    {
        RvParser *tempRvParserObj = [[RvParser alloc] init];
        NSArray *parsedArray = [tempRvParserObj mapptoModelClass:@"AFEBurnDownItem":data];
        requestInfoObj.resultObject = parsedArray;
        
        //[self.delegate rvAPIRequestCompletedSuccessfullyForRequest:requestInfoObj];
        
        [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionSuccessForRequest:) withObject:requestInfoObj waitUntilDone:NO];
    }
}

-(void) parseJsonToGetAFEBillingCategories:(NSString*) responseString forRequest:(RVAPIRequestInfo*) requestInfoObj{
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    NSDictionary *data= [responseString JSONValue];
    
    if(self.delegate)
    {
        
        NSString *errorCode = [data objectForKey:@"ecode"];
        NSString *errorMessage = [data objectForKey:@"msg"];
        
        if([errorCode isKindOfClass:[NSNull class]] || (errorCode && ![errorCode isEqualToString:@""]))
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
        
        NSArray *pageRecordsArray = [data objectForKey:@"bcpgrec"];
        
        RvParser *tempRvParserObj = [[RvParser alloc] init];
        NSArray *parsedArray = [tempRvParserObj mapptoModelClass:@"AFEInvoiceBillingCategory" :pageRecordsArray];
        [resultDict setObject:[NSNumber numberWithInt:totPageCount] forKey:@"totpgcnt"];
        [resultDict setObject:[NSNumber numberWithInt:totRecordCount] forKey:@"totrcnt"];
        [resultDict setObject:parsedArray?parsedArray:[[NSArray alloc] init] forKey:@"AFEBillingCategoryArray"];
        
        requestInfoObj.resultObject = resultDict;
        
        //[self.delegate rvAPIRequestCompletedSuccessfullyForRequest:requestInfoObj];
        
        [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionSuccessForRequest:) withObject:requestInfoObj waitUntilDone:NO];
        
    }    
}

-(void) parseJsonToGetAFEInvoice:(NSString*) responseString forRequest:(RVAPIRequestInfo*) requestInfoObj{   
   
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    NSDictionary *data= [responseString JSONValue];
    
    if(self.delegate)
    {
        
        NSString *errorCode = [data objectForKey:@"ecode"];
        NSString *errorMessage = [data objectForKey:@"msg"];
        
        if([errorCode isKindOfClass:[NSNull class]] || (errorCode && ![errorCode isEqualToString:@""]))
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
        
        NSArray *pageRecordsArray = [data objectForKey:@"ipgrec"];
        
        RvParser *tempRvParserObj = [[RvParser alloc] init];
        NSArray *parsedArray = [tempRvParserObj mapptoModelClass:@"AFEInvoice" :pageRecordsArray];
        [resultDict setObject:[NSNumber numberWithInt:totPageCount] forKey:@"totpgcnt"];
        [resultDict setObject:[NSNumber numberWithInt:totRecordCount] forKey:@"totrcnt"];
        [resultDict setObject:parsedArray?parsedArray:[[NSArray alloc] init] forKey:@"AFEInvoiceArray"];
                
        requestInfoObj.resultObject = resultDict;
        
        //[self.delegate rvAPIRequestCompletedSuccessfullyForRequest:requestInfoObj];
        
        [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionSuccessForRequest:) withObject:requestInfoObj waitUntilDone:NO];
        
    }
}

@end
