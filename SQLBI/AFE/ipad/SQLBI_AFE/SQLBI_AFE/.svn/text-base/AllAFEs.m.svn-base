//
//  AllAFEs.m
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 25/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AllAFEs.h"

@implementation AllAFEs

@synthesize afeID;
@synthesize afeName;
@synthesize afeNumber;

- (id)init
{
    self = [super init];
    if (self) {
        
        self.afeID = @"";
        self.afeName = @"";
        self.afeNumber = @"";
        
    }
    return self;
}

-(BOOL) isEqualTo:(AllAFEs*) objectToCompare
{
    BOOL result = NO;
    
    if(objectToCompare && [self.afeID caseInsensitiveCompare:objectToCompare.afeID] == NSOrderedSame)
    {
        result = YES;
    }
    
    return result;
}


-(void) setAfeID:(NSString *)afeIDNew
{
    if([afeIDNew isKindOfClass:[NSNumber class]])
    {
        afeID = [NSString stringWithFormat:@"%d", [afeIDNew intValue]];
    }
    else
    {
        afeID = afeIDNew;
    }

}


- (void)dealloc
{
    self.afeID = nil;
    self.afeName = nil;
    self.afeNumber = nil;

}

@end
