//
//  AFEBurnDown.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFEBurnDown.h"

@implementation AFEBurnDown

@synthesize budget,budgetAsStr;

-(id)init{
    self = [super init];
    if(self){
        self.budget = 0;
        self.budgetAsStr = @"";
    }
    return self;
}
-(void)dealloc {

    self.budgetAsStr = nil;

}

@end
