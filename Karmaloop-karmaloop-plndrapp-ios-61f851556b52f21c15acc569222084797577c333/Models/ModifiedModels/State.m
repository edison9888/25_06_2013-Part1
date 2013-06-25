//
//  States.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "State.h"

@implementation State

- (NSString*) description {
    return [NSString stringWithFormat:@"%@: shortName=%@ name=%@", [self class], self.shortName, self.name];
}

@end
