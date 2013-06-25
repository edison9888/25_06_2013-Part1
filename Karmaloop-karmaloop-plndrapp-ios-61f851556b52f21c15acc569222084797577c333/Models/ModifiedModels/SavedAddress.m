//
//  SavedAddress.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SavedAddress.h"
#import "Utility.h"
#import "NSNumber+JSON.h"

NSString* kSavedAddressValueBilling = @"Billing";
NSString* kSavedAddressValueShipping = @"Shipping";
@implementation SavedAddress

- (id)init {
    self = [super init];
    if (self) {
        self.address = [[Address alloc] init];
    }
    return self;
}

+ (int)getIndexOfDefaultSavedAddressOfType:(SavedAddressTypes)savedAddressType inArray:(NSArray *)array{
    for (int i = 0; i < array.count; i++) {
        SavedAddress *savedAddress = [array objectAtIndex:i];
        if (savedAddress.addressId.intValue == 0 && [savedAddress isSavedAddressOfType:savedAddressType] ) {
            return i;
        }
    }
    return -1;
}

- (BOOL)isSavedAddressOfType:(SavedAddressTypes)savedAddressType {
    NSString *typeOfAddress;
    switch (savedAddressType) {
        case SavedAddressBilling: {
            typeOfAddress = kSavedAddressValueBilling;
            break;
        }
        case SavedAddressShipping: {
            typeOfAddress = kSavedAddressValueShipping;
            break;
        }
            
        default: {
            typeOfAddress = @"";
            NSLog(@"SavedAddress Type Not Recognized: %@", savedAddressType);
            break;
        }
    }
    return [self.typeOfPrimary isEqualToString:typeOfAddress];
}

+ (NSString *)getSavedAddressTypeString:(SavedAddressTypes)savedAddressType {
    switch (savedAddressType) {
        case SavedAddressBilling: {
            return kSavedAddressValueBilling;
        }
        case SavedAddressShipping: {
            return kSavedAddressValueShipping;
        }
            
        default: {
            return @"";
            NSLog(@"SavedAddress Type Not Recognized: %@", savedAddressType);
        }
    }
}

- (NSArray *)getNameSummary {
    if (self.name .length > 0) {
        return [NSArray arrayWithObject:self.name];
    } else {
        return nil;
    }
}

- (NSDictionary *)getAPIDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.addressId, @"id",
            [Utility safeStringWithString:self.name], @"name",
            [self.isPrimary jsonBoolValue], @"isPrimary",
            [self.address getAPIDictionary], @"address",
            [Utility safeStringWithString:self.typeOfPrimary], @"type",
            nil];
}

@end
