//
//  AppUpdateManager.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 19/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppUpdateManager.h"

@interface AppUpdateManager ()
{
    AppVersion *latestAppVersion;
}

@property(nonatomic, strong) AFEUpdatesAPIHandler *apiHandlerUpdateManager;
@property(nonatomic, strong) NSMutableArray *apiRequestInfoObjectArray;

@end

static AppUpdateManager *sharedObject;

@implementation AppUpdateManager

@synthesize delegate;
@synthesize apiHandlerUpdateManager;
@synthesize apiRequestInfoObjectArray;

+(AppUpdateManager*) sharedManager
{
    if(!sharedObject)
    {
        sharedObject = [[AppUpdateManager alloc] init];
        
    }

    return sharedObject;
}


-(id) init
{
    self = [super init];
    
    if(self)
    {
        
    }
    
    return self;
}


-(void) checkForNewVersion
{
    [self initializeOrgSummaryAPIHandlerAndRequestArray];
    
    [self stopAPICallOfType:RVAPIRequestTypeGetAppVersion withTag:nil];
    
    if(self.apiHandlerUpdateManager)
    {
        NSString *appKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"App_Key"];
        
        RVAPIRequestInfo *tempRequestInfo = [self.apiHandlerUpdateManager getLatestAppVersionForApplicaitonKey:appKey];
        
        if(!self.apiRequestInfoObjectArray)
            self.apiRequestInfoObjectArray = [[NSMutableArray alloc] init];
    
        [self.apiRequestInfoObjectArray addObject:tempRequestInfo];
        
    }
}

-(void) installTheLatestVersion
{
    NSString *itmsURL;
    
    if(latestAppVersion)
    {
        itmsURL = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", latestAppVersion.urlToPlist];
        
        @try {
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(willInstallTheNewApplication)])
            {
                [self.delegate willInstallTheNewApplication];
            }
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itmsURL]];
        }
        @catch (NSException *exception) {
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(didFailInstallationOfTheNewVersion)])
            {
                [self.delegate didFailInstallationOfTheNewVersion];
            }
        }
        @finally {
        
        }
        
    }
}

-(void) initializeOrgSummaryAPIHandlerAndRequestArray
{
    if (!self.apiHandlerUpdateManager) {
        self.apiHandlerUpdateManager = [[AFEUpdatesAPIHandler alloc] init];
        apiHandlerUpdateManager.delegate = self;    
    }
    
    if(!self.apiRequestInfoObjectArray)
    {
        self.apiRequestInfoObjectArray = [[NSMutableArray alloc] init];
    }
}

-(void) stopAllAPICalls
{
    NSMutableArray *tempRequestInfoArray;
    
    if(apiRequestInfoObjectArray)
    {
        tempRequestInfoArray = [apiRequestInfoObjectArray copy];
        
        for(RVAPIRequestInfo *tempRequestInfo in tempRequestInfoArray)
        {
            if(tempRequestInfo)
            {
                [tempRequestInfo cancelAPIRequest];
                [self removeRequestInfoObjectFromPool:tempRequestInfo];
            }
        }
    }
}

-(void) stopAPICallOfType:(RVAPIRequestType) requestType withTag:(id) tag
{
    BOOL shouldCancel = NO;
    NSMutableArray *tempRequestInfoArray;
    
    if(apiRequestInfoObjectArray)
    {
        tempRequestInfoArray = [apiRequestInfoObjectArray copy];
        
        for(RVAPIRequestInfo *tempRequestInfo in tempRequestInfoArray)
        {
            shouldCancel = NO;
            
            if(tempRequestInfo && tempRequestInfo.requestType == requestType)
            {
                if(!tempRequestInfo.tag || !tag)
                {
                    shouldCancel = YES;
                }
                else if([tag isKindOfClass:[NSString class]] && [tempRequestInfo.tag isKindOfClass:[NSString class]])
                {
                    NSString *orginalTag = (NSString*) tempRequestInfo.tag;
                    NSString *tagToCompare = (NSString*) tag;
                    
                    if([orginalTag caseInsensitiveCompare:tagToCompare] == NSOrderedSame)
                        shouldCancel = YES;
                }
                else if(tag == tempRequestInfo.tag)
                {
                    shouldCancel = YES;
                }
                
                if(shouldCancel)
                {
                    [tempRequestInfo cancelAPIRequest];
                    [self removeRequestInfoObjectFromPool:tempRequestInfo];
                }
                
            }
        }
    }
    
}

-(BOOL) checkIfAPIRequestTypeAlive:(RVAPIRequestType) requestType withTag:(id) tag
{
    BOOL result = NO;
    
    if(self.apiRequestInfoObjectArray)
    {
        for(RVAPIRequestInfo *tempRequestInfo in self.apiRequestInfoObjectArray)
        {
            if(tempRequestInfo.requestType == requestType)
            {
                if(!tempRequestInfo.tag || !tag)
                {
                    result = YES;
                }
                else if([tag isKindOfClass:[NSString class]] && [tempRequestInfo.tag isKindOfClass:[NSString class]])
                {
                    NSString *orginalTag = (NSString*) tempRequestInfo.tag;
                    NSString *tagToCompare = (NSString*) tag;
                    
                    if([orginalTag caseInsensitiveCompare:tagToCompare] == NSOrderedSame)
                        result = YES;
                }
                else if(tag == tempRequestInfo.tag)
                {
                    result = YES;
                }
                
                if(result)
                {
                    break;     
                }              
            }
            
        }
    }
    
    return result;
}

-(void) removeRequestInfoObjectFromPool:(RVAPIRequestInfo*) requestinfoObj
{
    if(apiRequestInfoObjectArray)
    {
        [apiRequestInfoObjectArray removeObject:requestinfoObj];
    }
}


-(void) rvAPIRequestCompletedSuccessfullyForRequest:(RVAPIRequestInfo *)requestInfoObj
{
    NSArray *resultArray;
    
    [self removeRequestInfoObjectFromPool:requestInfoObj];
    
    switch (requestInfoObj.requestType) {
        case RVAPIRequestTypeGetAppVersion:
            
            resultArray = (NSArray*) requestInfoObj.resultObject;
            
            if(resultArray && resultArray.count > 0)
            {
                latestAppVersion = [resultArray objectAtIndex:0];
                
                [self didReceiveLatestVersionFromService];
            }
            else
            {
                latestAppVersion = nil;
                
                if(self.delegate && [self.delegate respondsToSelector:@selector(didFailToReceiveLatestVersionFromService)])
                {
                    [self.delegate didFailToReceiveLatestVersionFromService];
                }

            }
            
            break;
            
        default:
            break;
    }
}


-(void) rvAPIRequestCompletedWithErrorForRequest:(RVAPIRequestInfo *)requestInfoObj
{
    switch (requestInfoObj.requestType) {
        case RVAPIRequestTypeGetAppVersion:
            latestAppVersion = nil;
            break;
            
        default:
            latestAppVersion = nil;
            break;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFailToReceiveLatestVersionFromService)])
    {
        [self.delegate didFailToReceiveLatestVersionFromService];
    }
    
    
}


-(void) didReceiveLatestVersionFromService
{
    BOOL newVersionAvailable = NO;
    
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    NSArray *appVersionSplit = [appVersion componentsSeparatedByString:@"."];
    
    int localMajorVersion = 0;
    int localMinorVersion = 0;
    
    if(appVersionSplit && appVersionSplit.count > 0)
    {
        localMajorVersion = [[appVersionSplit objectAtIndex:0] intValue];
        localMinorVersion = (appVersionSplit.count>1)? [[appVersionSplit objectAtIndex:1] intValue]:0;
        
    }
    
    if(localMajorVersion < latestAppVersion.majorVersion)
    {
        newVersionAvailable = YES;
    }
    else if(localMinorVersion < latestAppVersion.minorVersion)
    {
        newVersionAvailable = YES;
    }
    
    if(newVersionAvailable)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(didFindNewVersionOfTheApplication:)])
        {
            [self.delegate didFindNewVersionOfTheApplication:latestAppVersion];
        }
    }
    else
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(didNotFindANewVersionOfTheApplication)])
        {
            [self.delegate didNotFindANewVersionOfTheApplication];
        }
    }
        
    
}


@end
