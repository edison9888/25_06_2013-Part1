//
//  WellSearchAPIHandler.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 23/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WellSearchAPIHandler.h"
#import "RvParser.h"
#import "AFE.h"

@implementation WellSearchAPIHandler
NSString * const kWellNames = @"/WellCompletionSearchResult";
NSString * const kWellDetails = @"/WellDetail";
NSString * const kAfe = @"/AFEs";


#pragma mark - Constructor

-(RVBaseAPIHandler*) init
{
    self = [super init];
    
    if(self)
        {
        
        }
    return self;
}

- (RVAPIRequestInfo*)getWellNames:(NSString *)text numbrOfRecod:(int)numOfRecod status:(NSString *)status {
    NSString *apiName = kWellNames;    
    NSString * paramString = @"";
    
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:text]];
    paramString = [paramString stringByAppendingFormat:@"/%d",numOfRecod];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:status]];
    
        //The below lines of code is important to keep track of the API request.
    RVBaseHttpHandler *objBaseHttpHandler = [[RVBaseHttpHandler alloc] init];
    objBaseHttpHandler.delegate = self;
    RVAPIRequestInfo *objRequestInfo = [[RVAPIRequestInfo alloc] init];
    objRequestInfo.gvAPIHandler = self;
    objRequestInfo.requestType = RVAPIRequestTypeGetWellNames;
    
    [baseHttpHandlersArray addObject:objBaseHttpHandler];
    [objBaseHttpHandler getRequest:apiName withParamString:paramString withRequestInfo:objRequestInfo];
    return objRequestInfo;
    
}
- (RVAPIRequestInfo*)getWellDetails :(NSString *)propertyID {
    NSString *apiName = kWellDetails;    
    NSString * paramString = @"";
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:propertyID]];
    
    //The below lines of code is important to keep track of the API request.
    RVBaseHttpHandler *objBaseHttpHandler = [[RVBaseHttpHandler alloc] init];
    objBaseHttpHandler.delegate = self;
    RVAPIRequestInfo *objRequestInfo = [[RVAPIRequestInfo alloc] init];
    objRequestInfo.gvAPIHandler = self;
    objRequestInfo.requestType = RVAPIRequestTypeGetWellDetails;
    
    [baseHttpHandlersArray addObject:objBaseHttpHandler];
    [objBaseHttpHandler getRequest:apiName withParamString:paramString withRequestInfo:objRequestInfo];
    return objRequestInfo;

}
- (RVAPIRequestInfo*)getAfe:(NSString *)propertyID status:(NSString *)status startDate:(NSString *)fromDate endDate:(NSString *)toDate categoryType:(NSString *)category sortFieldType:(NSString *)sortFieldBy sortOrderBy:(NSString*)sortBy pageNum:(int)page limit:(int)lmt{
    
    NSString *apiName = kAfe;    
    NSString * paramString = @"";
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:propertyID]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:status]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:fromDate]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:toDate]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:category]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:sortFieldBy]];
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:sortBy]];
    paramString = [paramString stringByAppendingFormat:@"?page=%d",page];
    paramString = [paramString stringByAppendingFormat:@"&limit=%d",lmt];
        //The below lines of code is important to keep track of the API request.
    RVBaseHttpHandler *objBaseHttpHandler = [[RVBaseHttpHandler alloc] init];
    objBaseHttpHandler.delegate = self;
    RVAPIRequestInfo *objRequestInfo = [[RVAPIRequestInfo alloc] init];
    objRequestInfo.gvAPIHandler = self;
    objRequestInfo.requestType = RVAPIRequestTypeGetAfe;
    [baseHttpHandlersArray addObject:objBaseHttpHandler];
    [objBaseHttpHandler getRequest:apiName withParamString:paramString withRequestInfo:objRequestInfo];
    return objRequestInfo;

}


#pragma mark - 

-(void) didReceiveResponseFromServer:(NSString *)responseData forRequest:(RVAPIRequestInfo *)requestInfoObj
{
    switch (requestInfoObj.requestType) {
        case RVAPIRequestTypeGetWellNames:
            [self parseJsonToGetWellNames:responseData forRequest:requestInfoObj];
            break;
        case RVAPIRequestTypeGetWellDetails:
            [self parseJsonToGetWellDetails:responseData forRequest:requestInfoObj];
            break;

        case RVAPIRequestTypeGetAfe:
            [self parseJsonToGetAFEs:responseData forRequest:requestInfoObj];
            break;
           
        default:
            break;
    }
    
}


#pragma mark - JSON Parsing methods

/*******************************************************************************
 *  Function Name: parseJsonToGetWellNames:forRequest
 *  Type: Synchronous
 *  Description: Parses the JSON response string for getWellNames async API request made.
 *  Parametrs:
 *              <responseString>: Response string from the baseHttpHandler.
 *              <requestInfoObj>: Request object associated to the async API call made.
 *  Return Values: requestInfoObj.resultObject will have an array of WellNames
 *                 objects in the system
 ********************************************************************************/

-(void) parseJsonToGetWellNames:(NSString*) responseString forRequest:(RVAPIRequestInfo*) requestInfoObj
{
    
    NSDictionary *data= [responseString JSONValue];
    
    if(self.delegate)
        {
        RvParser *tempRvParserObj = [[RvParser alloc] init];
        NSArray *parsedArray = [tempRvParserObj mapptoModelClass:@"WellName":data];
        requestInfoObj.resultObject = parsedArray;
        
        //[self.delegate rvAPIRequestCompletedSuccessfullyForRequest:requestInfoObj];
            
            [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionSuccessForRequest:) withObject:requestInfoObj waitUntilDone:NO];
            
        }
    
    
}
-(void) parseJsonToGetWellDetails:(NSString*) responseString forRequest:(RVAPIRequestInfo*) requestInfoObj
{
    
    NSDictionary *data= [responseString JSONValue];
    
    if(self.delegate)
        {
        RvParser *tempRvParserObj = [[RvParser alloc] init];
        NSArray *parsedArray = [tempRvParserObj mapptoModelClass:@"WellDetail":data];
        requestInfoObj.resultObject = parsedArray;
        
        //[self.delegate rvAPIRequestCompletedSuccessfullyForRequest:requestInfoObj];
            
            [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionSuccessForRequest:) withObject:requestInfoObj waitUntilDone:NO];
            
        }
    
    
}
-(void) parseJsonToGetAFEs:(NSString*) responseString forRequest:(RVAPIRequestInfo*) requestInfoObj
{
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    NSDictionary *data= [responseString JSONValue];
    NSString *errorCode = [data objectForKey:@"ecode"];
    NSString *errorMessage = [data objectForKey:@"msg"];
    
    
    if(self.delegate){
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
         NSArray *pageRecordsArray = [data valueForKey:@"afepgrec"]; 

            RvParser *tempRvParserObj = [[RvParser alloc] init];
            NSArray *parsedArray = [tempRvParserObj mapptoModelClass:@"AFE":pageRecordsArray];
            [resultDict setObject:[NSNumber numberWithInt:totPageCount] forKey:@"totpgcnt"];
            [resultDict setObject:[NSNumber numberWithInt:totRecordCount] forKey:@"totrcnt"];
            [resultDict setObject:parsedArray?parsedArray:[[NSArray alloc] init] forKey:@"AFEArray"];
            int i=0;
            for( i=0;i<[parsedArray count];i++){
                AFE *tempAFe = [parsedArray objectAtIndex:i];
            }
    requestInfoObj.resultObject = resultDict;
    //[self.delegate rvAPIRequestCompletedSuccessfullyForRequest:requestInfoObj];
        
        [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionSuccessForRequest:) withObject:requestInfoObj waitUntilDone:NO];
        
    }
}




@end
