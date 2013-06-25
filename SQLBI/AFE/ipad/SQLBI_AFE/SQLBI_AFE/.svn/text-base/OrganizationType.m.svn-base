//
//  OrganizationType.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OrganizationType.h"

@implementation OrganizationType

@synthesize displayName,type;

-(id)init{

    self = [super init];
    if(self){
        self.displayName =@"";
        self.type =@"";
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:displayName forKey:@"displayName"];
    [coder encodeObject:type forKey:@"type"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil)
    {
        self.displayName  = [coder decodeObjectForKey:@"displayName"];
        self.type         = [coder decodeObjectForKey:@"type"];
    }
    return self;
}



-(BOOL) isEqualTo:(OrganizationType*) objectToCompare
{
    BOOL result = NO;
    
    if(objectToCompare && [self.type caseInsensitiveCompare:objectToCompare.type] == NSOrderedSame)
    {
        result = YES;
    }
    
    return result;
}


-(void)dealloc {
    
    self.displayName = nil;
    self.type = nil;
}
@end
