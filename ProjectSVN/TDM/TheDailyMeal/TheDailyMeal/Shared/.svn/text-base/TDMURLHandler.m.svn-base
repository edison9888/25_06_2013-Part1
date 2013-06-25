//
//  TDMURLHandler.m
//  TheDailyMeal
//
//  Created by Nithin George on 06/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMURLHandler.h"
//#import "RBConstants.h"//prod/test server macro


@implementation TDMURLHandler

NSString * const kURLWebServerPROD = @"https://api.foursquare.com";
NSString * const kURLWebServerPRODHTTPS = @"https://api.foursquare.com";
NSString * const kURLWebServerQA = @"https://api.foursquare.com";
NSString * const kTDMURLPrefix = @"http://stage.thedailymeal.com:8081/rest";

//NSString * const kURLWebServerQA = @"https://api.foursquare.com";


+ (BOOL)useHttpsService:(TDMHTTPRequestType)requestType {
    
    BOOL useHttps = NO;
    if(requestType == kCurrentLocationBusinessDetails ) 
    {    
        useHttps = YES;
    }
    
    else if (requestType == kTDMLogout) 
    {
        useHttps = NO;
    }
    return useHttps;
}

+ (NSString*)RBWEBSERVERURL:(TDMHTTPRequestType)requestType
{
	NSString *result = nil;
//#ifdef PROD_CONFIG
//    if(requestType && [self useHttpsService:requestType])
//        result = kURLWebServerPRODHTTPS;
//    else    
//        result = kURLWebServerPROD;
//#else
//	result = kURLWebServerQA;
//#endif
    
    if (requestType) {
        if(requestType == kCurrentLocationBusinessDetails) {
            result = kURLWebServerQA;
        }
        if(requestType == kTDMLogout){
            result = kTDMURLPrefix;
        }
        if (requestType == kTDMLogin) {
            result = kTDMURLPrefix;
        }
        if (requestType == kTDMForgotPassword) {
            result = kTDMURLPrefix;
        }
        if (requestType == kTDMSignup) {
            result = kTDMURLPrefix;
        }
        if (requestType == kTDMBusinessHome) {
            result = kTDMURLPrefix;
        }
        if (requestType == kTDMBusinessReview) {
            result = kTDMURLPrefix;
        }
        if (requestType == kTDMCityGuideListOfCities) {
            result = kTDMURLPrefix;
        }
        if (requestType == kTDMCityGuideListOfRestaurants) {
            result = kTDMURLPrefix;
        }
        if (requestType == kTDMBusinessSignatureDishes) {
            result = kTDMURLPrefix;
        }
        if (requestType == kTDMBusinessReviewList) {
            result = kTDMURLPrefix;
        }
        if (requestType == kTDMUserProfile) {
            result = kTDMURLPrefix;
        }
        if (requestType == kTDMPhotUpload) {
            result = kTDMURLPrefix;
        }
        if (requestType == kTDMAddSignatureDish) {
            result = kTDMURLPrefix;
        }
        if (requestType == kTDMFilePUT) {
            result = kTDMURLPrefix;
        }
        if (requestType == kTDMFoursquareBrowse) {
            result = kURLWebServerQA;
        }
        if (requestType == kTDMFoursquareName) {
            result = kURLWebServerQA;
        }
        if (requestType == kTDMSignUpWithImage) {
            result = @"";
        }
        if (requestType == kTDMSignup) {
            result = kTDMURLPrefix;
        }
    }
    
	return result;
}





@end
