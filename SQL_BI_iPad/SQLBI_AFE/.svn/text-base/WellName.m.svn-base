//
//  WellName.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 23/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WellName.h"

@implementation WellName
@synthesize propertyID;
@synthesize propertyName;
@synthesize status;

- (id)init
{
    self = [super init];
    if (self) {
        
        self.propertyID = @"";
        self.propertyName = @"";
        self.status = @"";
        
    }
    return self;
}

-(BOOL) isEqualTo:(WellName*) objectToCompare
{
    BOOL result = NO;
    
    if(objectToCompare && [self.propertyID caseInsensitiveCompare:objectToCompare.propertyID] == NSOrderedSame)
    {
        result = YES;
    }
    
    return result;
}

-(void) setPropertyID:(NSString *)propertyIDNew
{
    if([propertyIDNew isKindOfClass:[NSNumber class]])
    {
        propertyID = [NSString stringWithFormat:@"%d", [propertyIDNew intValue]];
    }
    else
    {
            propertyID = propertyIDNew;
    }

}

- (void)dealloc
{
    self.propertyID = nil;
    self.propertyName = nil;
    self.status = nil;
}
@end
