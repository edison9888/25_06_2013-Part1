//
//  AFEObject.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFEObject.h"

@implementation AFEObject
@synthesize afeID;
@synthesize afeNumber;
@synthesize name;


-(id)init {
    self = [super init];
    if(self){
        self.afeID = @"";
        self.afeNumber = @"";
        self.name =@"";
    }
    return self;
}

-(void)dealloc {
    self.afeID = nil;
    self.afeNumber = nil;
    self.name = nil;
}
@end
