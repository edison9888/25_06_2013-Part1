//
//  ShippingDetails.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShippingDetails.h"
#import "ShippingOption.h"

@implementation ShippingDetails

- (NSDictionary *)getAPIDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [self.address getAPIDictionary], @"address",
            self.method, @"method",
            [ShippingOption getAPIShippingOptionsForShippingOptions:self.options], @"options",
            nil];
}

@end
