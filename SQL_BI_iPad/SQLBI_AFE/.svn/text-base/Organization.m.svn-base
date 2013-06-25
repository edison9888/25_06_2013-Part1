//
//  Organization.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Organization.h"

@implementation Organization
@synthesize orgID,orgName;

-(id)init{
    
    self = [super init];
    if(self){
        self.orgID =@"";
        self.orgName =@"";
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:orgID forKey:@"orgID"];
    [coder encodeObject:orgName forKey:@"orgName"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil)
    {
        self.orgID  = [coder decodeObjectForKey:@"orgID"];
        self.orgName         = [coder decodeObjectForKey:@"orgID"];
    }
    return self;
}


-(BOOL) isEqualTo:(Organization*) objectToCompare
{
    BOOL result = NO;
    
    if(objectToCompare && [self.orgID caseInsensitiveCompare:objectToCompare.orgID] == NSOrderedSame)
    {
        result = YES;
    }
    
    return result;
}

-(void)dealloc {
    
    self.orgID = nil;
    self.orgName = nil;
    
    
}


@end
