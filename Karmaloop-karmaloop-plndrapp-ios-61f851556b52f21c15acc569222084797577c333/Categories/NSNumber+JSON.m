//
//  NSNumber+JSON.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSNumber+JSON.h"

@implementation NSNumber (JSON)

- (NSString *)jsonBoolValue {
    if (self.boolValue == YES) {
        return @"true";
    } else {
        return @"false";
    }
}

@end
