//
//  Address.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Address.h"
#import "Country.h"
#import "State.h"
#import "ModelContext.h"
#import "PlndrPurchaseSession.h"
#import "Utility.h"

@implementation Address

@synthesize countryIndex = _countryIndex,
stateIndex = _stateIndex;


- (BOOL)isComplete {
    return ((self.firstName.length > 0) && 
            (self.lastName.length > 0) && 
            (self.address1.length > 0) && 
            (self.city.length >0) && 
            (self.state.length >0) && 
            (self.postalCode.length > 0) && 
            (self.country.length > 0));
}

- (id)copyWithZone:(NSZone *)zone {
    Address *copyAddr = [super copyWithZone:zone];

    copyAddr.countryIndex = [self.countryIndex copy];
    copyAddr.stateIndex = [self.stateIndex copy];
    
    return copyAddr;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    Address *otherAddress = (Address*)object;
    return ((self.firstName == otherAddress.firstName || [self.firstName isEqualToString:otherAddress.firstName]) &&
            (self.lastName == otherAddress.lastName || [self.lastName isEqualToString:otherAddress.lastName]) &&
            (self.attention == otherAddress.attention || [self.attention isEqualToString:otherAddress.attention]) && 
            (self.address1 == otherAddress.address1 || [self.address1 isEqualToString:otherAddress.address1]) &&
            (self.address2 == otherAddress.address2 || [self.address2 isEqualToString:otherAddress.address2]) &&
            (self.address3 == otherAddress.address3 || [self.address3 isEqualToString:otherAddress.address3]) &&
            (self.city == otherAddress.city || [self.city isEqualToString:otherAddress.city]) && 
            (self.state == otherAddress.state || [self.state isEqualToString:otherAddress.state]) &&
            (self.country == otherAddress.country || [self.country isEqualToString:otherAddress.country]) &&
            (self.postalCode == otherAddress.postalCode || [self.postalCode isEqualToString:otherAddress.postalCode]) &&
            (self.phone == otherAddress.phone || [self.phone isEqualToString:otherAddress.phone]));
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: %@ %@ %@ %@ %@ %@ %@ %@ %@ %@", [self class], self.lastName, self.firstName, self.address1, self.address2, self.address3, self.city, self.state, self.country, self.postalCode, self.phone];
}

- (NSArray *)getSummaryStrings {
    if ([self isComplete]) {
        NSMutableArray *addressSummaryStrings = [[NSMutableArray alloc] init];
        if (self.firstName.length > 0 || self.lastName.length > 0) {
            [addressSummaryStrings addObject:[NSString stringWithFormat:@"%@%@%@", 
                                                      self.firstName,
                                                      (self.firstName.length > 0 && self.lastName.length > 0) ? @" " : @"", 
                                                      self.lastName]];
        }
        if (self.address1.length > 0) {
            [addressSummaryStrings addObject:[NSString stringWithFormat:@"%@", self.address1]];
        }
        if (self.address2.length > 0) {
            [addressSummaryStrings addObject:[NSString stringWithFormat:@"%@", self.address2]];
        }
        if (self.address3.length > 0) {
            [addressSummaryStrings addObject:[NSString stringWithFormat:@"%@", self.address3]];
        }        
        if ((self.city.length > 0) && (self.state.length > 0) &&  (self.postalCode.length > 0) && (self.country.length > 0)) {
            [addressSummaryStrings addObject:[NSString stringWithFormat:@"%@ %@ %@ %@",
                                                      self.city,
                                                      self.state,
                                                      self.postalCode,
                                                      self.country]];
        }
        
        return addressSummaryStrings;
    } else {
        return nil;
    }
}

- (void)rectifyIndexAndStringStates {
    NSArray *countries = [[[ModelContext instance] plndrPurchaseSession] countries];
    Country *selectedCountry = nil;
    
    if (self.country.length > 0) {
        self.countryIndex = nil;
        self.stateIndex = nil;
        // A country (and state) is set. Set the country and state indexes to match
        for (Country *country in countries) {
            if ([self.country isEqualToString:country.shortName]) {
                self.countryIndex = [NSNumber numberWithInt:[countries indexOfObject:country]];
                selectedCountry = country;
                
                for (State *state in selectedCountry.states) {
                    if ([self.state isEqualToString:state.shortName]) {
                        self.stateIndex = [NSNumber numberWithInt:[selectedCountry.states indexOfObject:state]];
                    }
                }
            }
        }
    }
}

- (NSDictionary *)getAPIDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [Utility safeStringWithString:self.firstName], @"firstName",
            [Utility safeStringWithString:self.lastName], @"lastName",
            @"", @"email",
            [Utility safeStringWithString:self.attention], @"attention",
            [Utility safeStringWithString: self.address1], @"address1",
            [Utility safeStringWithString: self.address2], @"address2",
            [Utility safeStringWithString: self.address3], @"address3",
            [Utility safeStringWithString: self.city], @"city",
            [Utility safeStringWithString: self.state], @"state",
            [Utility safeStringWithString: self.country], @"country",
            [Utility safeStringWithString: self.postalCode], @"postalCode",
            [Utility safeStringWithString:self.phone], @"phone",
            nil];
}

- (NSArray *)getCountryIndexArray {
    NSMutableArray *array  = [NSMutableArray array];
    if (self.countryIndex) {
        [array addObject:self.countryIndex];
    } else {
        [array addObject:[NSNumber numberWithInt:0]];
    }
    return array;
    
}

- (NSArray *)getStateIndexArray {
    NSMutableArray *array  = [NSMutableArray array];
    if (self.stateIndex) {
        [array addObject:self.stateIndex];
    } else {
        [array addObject:[NSNumber numberWithInt:0]];
    }
    return array;
    
}

- (NSArray *)getCountryAndStateIndexArray {
    NSMutableArray *array  = [NSMutableArray array];
    if (self.countryIndex) {
        [array addObject:self.countryIndex];
    } else {
        [array addObject:[NSNumber numberWithInt:0]];
    }
    if (self.countryIndex && self.stateIndex) {
        [array addObject:self.stateIndex];                       
    } else {
        [array addObject:[NSNumber numberWithInt:0]];
    }

    return array;
}

@end
