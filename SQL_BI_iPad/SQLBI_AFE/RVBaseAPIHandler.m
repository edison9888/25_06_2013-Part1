//
//  RVBaseAPIHandler.m
//  SQLandBI
//
//  Created by Runi Kovoor on 18/01/12.
//  Copyright (c) 2012 Rapid Value Solution. All rights reserved.
//

#import "RVBaseAPIHandler.h"

NSString * const kGetStatusTypes = @"/StatusTypes";

@interface RVBaseAPIHandler(PVT)

-(void) parseJsonToGetUserInfo:(NSString*) responseString forRequest:(RVAPIRequestInfo*) requestInfoObj;


////added By Bittu
//- (NSString *)getActualDateFrom:(NSString*)epochTime;
//
//- (NSString*)getActualTimeStringFrom:(NSString*)epochTime;
//
//- (NSDate *)dateWithOutTime:(NSDate *)datDate;
//
//- (NSString *)getSQLandBIStandardDateAndTimeFromDate:(NSDate *)date;
//
//-(NSString *)getActualDateFromInSCPBootCase:(NSString*)epochTime;

-(BOOL) checkIfResultHasError:(NSDictionary*) resultDict;


@end

@implementation RVBaseAPIHandler

@synthesize delegate;

#pragma mark - API Names

NSString * const kGetUserInfo = @"/GetUserInfo";
NSString * const kGetReportsList = @"/GetReportsList";


#pragma mark - API Params
NSString * const kUsername = @"username";
NSString * const kcommandIDs= @"commandIDs";


#pragma mark - Constructor

-(RVBaseAPIHandler*) init
{
    self = [super init];
    
    if(self)
    {
            baseHttpHandlersArray = [[NSMutableArray alloc] init];     
    }
    return self;
}


#pragma mark GVAPIHandler Methods
/*******************************************************************************
 *  Function Name: getUserInfoWithUsername:andPassword
 *  Type: Asynchronous
 *  Description: To get a users information including the Session Token. 
 *  Parametrs:
 *              <username>: Username of the user
 *              <password>: Password of the user
 *  Return Values: RVAPIRequestInfo object representing the API request made. This 
 *                 can be used to keep track of the API request and result data.
 ********************************************************************************/

- (RVAPIRequestInfo*) getStatusTypes
{
    NSString *apiName = kGetStatusTypes;    
    NSString * paramString = @"";
    
    //The below lines of code is important to keep track of the API request.
    RVBaseHttpHandler *objBaseHttpHandler = [[RVBaseHttpHandler alloc] init];
    objBaseHttpHandler.delegate = self;
    RVAPIRequestInfo *objRequestInfo = [[RVAPIRequestInfo alloc] init];
    objRequestInfo.gvAPIHandler = self;
    objRequestInfo.requestType = RVAPIRequestTypeGetStatusTypes;
    
    [baseHttpHandlersArray addObject:objBaseHttpHandler];
    [objBaseHttpHandler getRequest:apiName withParamString:paramString withRequestInfo:objRequestInfo];
    
    return objRequestInfo;

}


#pragma mark - API request related methods

-(void) cancelAPIRequestWithRequestInfo:(RVAPIRequestInfo *) requestInfo
{
    if([baseHttpHandlersArray count] > 0)
    {
        for(int i = 0; i < [baseHttpHandlersArray count]; i++)
        {
            RVBaseHttpHandler *tempHttpHandler = (RVBaseHttpHandler*) [baseHttpHandlersArray objectAtIndex:i];
            if(tempHttpHandler.requestinfo == requestInfo)
            {
                NSLog(@"Stopping anyother API Calls in place");
                [tempHttpHandler cancelHttpRequest];
                requestInfo.statusCode = RVAPIResponseStatusCodeRequestCanceled;
                requestInfo.statusMessage = @"Request Canceled";
                [baseHttpHandlersArray removeObjectAtIndex:i];
              
//                if(self.delegate && [self.delegate respondsToSelector:@selector(rvAPIRequestCompletedWithErrorForRequest:)])
//                {
//                    [self.delegate rvAPIRequestCompletedWithErrorForRequest:requestInfo];
//                }
                
                break;
            }
        }
    }
}


- (void)requestCompletedSuccessfully:(NSString*) responseData forRequest:(RVAPIRequestInfo*) requestInfoObj
{
    if(requestInfoObj.statusCode != RVAPIResponseStatusCodeRequestCanceled)
    { 
        //[self didReceiveResponseFromServer:responseData forRequest:requestInfoObj];
        
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
        
        [tempDict setObject:responseData?responseData:[NSNull null] forKey:@"ResponseData"];
        [tempDict setObject:requestInfoObj?requestInfoObj:[NSNull null] forKey:@"RequestInfo"];
        
        [self performSelectorInBackground:@selector(passObjectsInDictionaryToDidReceiveResponseMethod:) withObject:tempDict];
        
    }
    
}

-(void) passObjectsInDictionaryToDidReceiveResponseMethod:(NSDictionary*) passDict
{
    NSString *responseData = [passDict objectForKey:@"ResponseData"];
    RVAPIRequestInfo *requestInfoObj = [passDict objectForKey:@"RequestInfo"];
    
    switch (requestInfoObj.requestType) {
        case RVAPIRequestTypeGetStatusTypes:
            [self parseJsonToGetStatusTypes:responseData forRequest:requestInfoObj];
            break;
        default:
            [self didReceiveResponseFromServer:responseData forRequest:requestInfoObj];
            break;
    }
    
    [self removeHttpHandlerFromArrayForRequest:requestInfoObj];
}

- (void)requestFailedWithError:(RVAPIResponseStatusCode) errorCode message:(NSString*) errorMessage  forRequestType:(RVAPIRequestInfo*) requestInfoObj
{
    if(requestInfoObj.statusCode == RVAPIResponseStatusCodeRequestCanceled)
        return;
    
    requestInfoObj.statusCode = errorCode;
    requestInfoObj.statusMessage = errorMessage;
    requestInfoObj.resultObject = NULL;
    
    if(self.delegate)
    {
        [self.delegate rvAPIRequestCompletedWithErrorForRequest:requestInfoObj];
    }
    
    [self removeHttpHandlerFromArrayForRequest:requestInfoObj];
    
}


-(void) removeHttpHandlerFromArrayForRequest:(RVAPIRequestInfo*) requestInfoObj
{
    
    //This is to remove this partivcular base http call as it is completed. 
    //This is done to handle considering mutiple request made using the same object of
    //APIHelper class.
    if([baseHttpHandlersArray count] > 0)
    {
        for(int i = 0; i < [baseHttpHandlersArray count]; i++)
        {
            RVBaseHttpHandler *tempHttpHandler = (RVBaseHttpHandler*) [baseHttpHandlersArray objectAtIndex:i];
            if(tempHttpHandler.requestinfo == requestInfoObj)
            {
                [baseHttpHandlersArray removeObjectAtIndex:i];
                tempHttpHandler = nil;
                break;
            }
        }
    }

    
}


//Override this method to process the response data from server.
//Ususally the data from the server is to be a JSON or XML, whcih needs to be
//Parsed and sent back to the delegate.
-(void) didReceiveResponseFromServer:(NSString*) responseData forRequest:(RVAPIRequestInfo*) requestInfoObj
{
    
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

-(void) parseJsonToGetStatusTypes:(NSString*) responseString forRequest:(RVAPIRequestInfo*) requestInfoObj
{
    NSMutableArray *resultArray;
    
    NSArray *data= [responseString JSONValue];
    
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
        
        resultArray = [[NSMutableArray alloc] init];
        
        NSDictionary *tempDictionary;
        for(int i =0; i < data.count; i++)
        {
            tempDictionary = [data objectAtIndex:i];
            
            NSString *value;
            if(tempDictionary && [tempDictionary objectForKey:@"stt"])
            {
                value = (NSString*) [tempDictionary objectForKey:@"stt"];
                
                if(value && ![value isEqualToString:@""])
                    [resultArray addObject:value];
            }
            
        }

        requestInfoObj.resultObject = resultArray;
        
        [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionSuccessForRequest:) withObject:requestInfoObj waitUntilDone:NO];
    }
    
    
}




#pragma mark - UIAlertView Delegate
//this is the AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    exit(1);
    
}

@end
