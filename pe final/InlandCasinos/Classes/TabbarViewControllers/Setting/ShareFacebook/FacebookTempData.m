//
//  FacebookTempData.m
//  InlandCasinos
//
//  Created by Sagar S. Kadookkunnan on 18/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FacebookTempData.h"


@implementation FacebookTempData

static  FacebookTempData *sharedInstance;

static  NSString    *strImageUrl;

static  NSString    *strFBDescription;

static  NSString    *strShareUrl;

+(FacebookTempData *)sharedManager
{
    if (sharedInstance == nil)
    {
        sharedInstance  =   [[FacebookTempData alloc] init];
    }
    
    return sharedInstance;
}

-(void)setFBShareImageURL :(NSString *)strUrl
{
    strImageUrl =   strUrl;
}

-(NSString *)getFBShareImageURL
{
    return strImageUrl;
}

-(void)setFBDescription :(NSString *)strDescription
{
    strFBDescription    =   strDescription;
}

-(NSString *)getFBDescription
{
    return strFBDescription;
}

-(void)setFBShareUrl :(NSString *)strUrl
{
    strShareUrl =   strUrl;
}

-(NSString *)getFBShareUrl
{
    return strShareUrl;
}

@end
