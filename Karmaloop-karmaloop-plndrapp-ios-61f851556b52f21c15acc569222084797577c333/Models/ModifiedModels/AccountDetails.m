//
//  AccountDetails.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccountDetails.h"
#import "Utility.h"


@implementation AccountDetails

// These values must be exactly as they are for API use.
NSString *kUnknown = @"Unknown";
NSString *kMale = @"Male";
NSString *kFemale = @"Female";

@synthesize birthday = _birthday;

NSString *kBirthdayCodingKey = @"kBirthdayCodingKey";


- (void)postProcessData {
    _birthday = [Utility dateFromISO8601:self.birthdayRaw];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_birthday forKey:kBirthdayCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    _birthday = [aDecoder decodeObjectForKey:kBirthdayCodingKey];
    return self;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@: name=%@ %@ customerId=%d", [self class], self.firstName, self.lastName, self.customerId];
}

- (id)copyWithZone:(NSZone *)zone {
    AccountDetails *accountDetails = [super copyWithZone:zone];
    accountDetails.birthday = self.birthday;
    return accountDetails;
}

@end

