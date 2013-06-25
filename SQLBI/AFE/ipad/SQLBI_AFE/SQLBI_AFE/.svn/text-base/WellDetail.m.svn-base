//
//  WellDetail.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WellDetail.h"

@implementation WellDetail

@synthesize wellName;
@synthesize api;
@synthesize unitLease;
@synthesize district;
@synthesize subArea;
@synthesize businessUnit;
@synthesize area;
@synthesize afeClassName;
@synthesize operated;
@synthesize workingInterest;
@synthesize spudDate;
@synthesize oilNri;
@synthesize gasNri;

- (id)init
{
    self = [super init];
    if (self) {
        self.wellName = @"";
        self.api = @"";
        self.unitLease = @"";
        self.district = @"";
        self.businessUnit = @"";
        self.area = @"";
        self.afeClassName = @"";
        self.operated = NO;
        self.workingInterest = 0;
        self.spudDate = nil;
        self.oilNri = 0;
        self.gasNri = 0;
    }
    return self;
}

-(BOOL) isEqualTo:(WellDetail*) objectToCompare
{
    BOOL result = NO;
    
    if(objectToCompare && ([self.wellName caseInsensitiveCompare:objectToCompare.wellName] == NSOrderedSame) && ([self.afeClassName caseInsensitiveCompare:objectToCompare.afeClassName] == NSOrderedSame))
    {
        result = YES;
    }
    
    return result;
}

- (void)dealloc
{
    self.wellName = nil;
    self.api = nil;
    self.unitLease = nil;
    self.district = nil;
    self.businessUnit = nil;
    self.area = nil;
    self.afeClassName = nil;
    self.spudDate = nil;
}

@end
