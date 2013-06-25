//
//  Country.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Country.h"

@implementation Country

- (NSString*) description {
    return [NSString stringWithFormat:@"%@: shortName=%@ name=%@ states=%@", [self class], self.shortName, self.name, self.states];
}

@end
