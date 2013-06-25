//
//  AppVersion.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 19/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppVersion.h"

@implementation AppVersion
@synthesize majorVersion, minorVersion, serviceMajorVersion, serviceMinorVersion, versionAsStr, serviceVersionAsStr, urlToPlist;

- (id)init
{
    self = [super init];
    if (self) {
               
        majorVersion = 0;
        minorVersion = 0;
        serviceMajorVersion = 0;
        serviceMinorVersion = 0;
        versionAsStr = @"0.0";
        serviceVersionAsStr = @"0.0";
        urlToPlist = @"";
        
    }
    return self;
}


- (void)dealloc{
    
    self.serviceVersionAsStr = nil;
    self.VersionAsStr = nil;
    self.urlToPlist = nil;
    
}


@end
