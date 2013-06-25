//
//  AFEUpdatesAPIHandler.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 19/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFEUpdatesAPIHandler.h"
#import "RvParser.h"

@interface AFEUpdatesAPIHandler ()

-(void) parseJsonToGetLatestAppVersion:(NSString*) responseString forRequest:(RVAPIRequestInfo*) requestInfoObj;

@end

@implementation AFEUpdatesAPIHandler

NSString * const kAppVersion = @"/AppVersion";

-(RVBaseAPIHandler*) init
{
    self = [super init];
    
    if(self)
    {
        
    }
    return self;
}


-(RVAPIRequestInfo*) getLatestAppVersionForApplicaitonKey:(NSString *)appKey
{
    NSString *apiName = kAppVersion;    
    NSString * paramString = @"";
    
    paramString = [paramString stringByAppendingFormat:@"/%@",[RVAPIConstants urlEncodedParamStringFromString:appKey]];
    
    //The below lines of code is important to keep track of the API request.
    RVBaseHttpHandler *objBaseHttpHandler = [[RVBaseHttpHandler alloc] init];
    objBaseHttpHandler.delegate = self;
    RVAPIRequestInfo *objRequestInfo = [[RVAPIRequestInfo alloc] init];
    objRequestInfo.gvAPIHandler = self;
    objRequestInfo.requestType = RVAPIRequestTypeGetAppVersion;
    
    [baseHttpHandlersArray addObject:objBaseHttpHandler];
    [objBaseHttpHandler getRequest:apiName withParamString:paramString withRequestInfo:objRequestInfo];
    
    return objRequestInfo;

}


-(void) didReceiveResponseFromServer:(NSString *)responseData forRequest:(RVAPIRequestInfo *)requestInfoObj
{
    
    switch (requestInfoObj.requestType) {
        case RVAPIRequestTypeGetAppVersion:
            [self parseJsonToGetLatestAppVersion:responseData forRequest:requestInfoObj];
            break;
                   
        default:
            break;
    }
}


-(void) parseJsonToGetLatestAppVersion:(NSString *)responseString forRequest:(RVAPIRequestInfo *)requestInfoObj
{
    NSDictionary *data= [responseString JSONValue];
    
    if(self.delegate)
    {
        if(!data)
        {
            requestInfoObj.statusCode = RVAPIResponseStatusCodeGenericServerError;
            requestInfoObj.statusMessage = @"Unable to reach the service!";
            
            [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionWithErrorsForRequest:) withObject:requestInfoObj waitUntilDone:NO];
            
            return;
        }
        else
        {
            NSString *erroMessage = [data objectForKey:@"ErrorMessage"];
            BOOL succeeded =  [data objectForKey:@"Succeeded"]? [[data objectForKey:@"Succeeded"] boolValue]:NO;
            
            if(!succeeded)
            {
                if(erroMessage)
                    requestInfoObj.statusMessage = erroMessage;
                else
                    requestInfoObj.statusMessage = @"Failed for get App Version from the Server.";
                
                requestInfoObj.statusCode = RVAPIResponseStatusCodeGenericServerError;
                
                [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionWithErrorsForRequest:) withObject:requestInfoObj waitUntilDone:NO];
                
                return;
            }
            
        }
        
        NSDictionary *versionObject = [data objectForKey:@"Version"];
        
        RvParser *tempRvParserObj = [[RvParser alloc] init];
        NSArray *parsedArray = [tempRvParserObj mapptoModelClass:@"AppVersion":versionObject];
        requestInfoObj.resultObject = parsedArray;
        
        [self performSelectorOnMainThread:@selector(callBackOnParsingCompletionSuccessForRequest:) withObject:requestInfoObj waitUntilDone:NO];
        
    }
}


@end
