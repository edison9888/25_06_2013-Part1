//
//  LoginSession.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginSession.h"
#import "ModelContext.h"
#import "PlndrPurchaseSession.h"
#import "SavedAddress.h"

@interface LoginSession ()

- (void) commonInit;

@end

@implementation LoginSession

@synthesize username = _username, password = _password;
@synthesize authToken = _authToken;
@synthesize addresses = _addresses;
@synthesize defaultShippingAddressIndex = _defaultShippingAddressIndex;
@synthesize defaultBillingAddressIndex = _defaultBillingAddressIndex;
@synthesize accountDetails = _accountDetails;
@synthesize lastTimeSavedAddressesWereFetched = _lastTimeSavedAddressesWereFetched;

NSString *LoginUsernameCodingKey = @"LoginUsernameCodingKey";
NSString *LoginAuthTokenCodingKey = @"LoginAuthTokenCodingKey";

- (id)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        [self commonInit];
        
        self.username = [aDecoder decodeObjectForKey:LoginUsernameCodingKey];
        self.authToken = [aDecoder decodeObjectForKey:LoginAuthTokenCodingKey];
    }
    return self;
}

- (void) commonInit {
    self.addresses = [NSMutableArray array];
    self.defaultBillingAddressIndex = -1;
    self.defaultShippingAddressIndex = -1;
}

- (BOOL) isLoggedIn {
    return ([self.authToken length] > 0);
}

- (void) logout {
    self.authToken = nil;
    self.username = nil;
    self.password = nil;
    self.accountDetails = nil;
    
    [self resetAddressBook];
    [ModelContext instance].plndrPurchaseSession = nil;
    
    [[ModelContext instance] saveLoginSessionToDisk];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_username forKey:LoginUsernameCodingKey];
    [aCoder encodeObject:_authToken forKey:LoginAuthTokenCodingKey];
}

- (SavedAddress *) getShippingSavedAddress {
    if (self.defaultShippingAddressIndex >=0) {
        SavedAddress *savedAddress = [self.addresses objectAtIndex:self.defaultShippingAddressIndex];
        return savedAddress;
    } else {
        return nil;
    }
}

- (SavedAddress *) getBillingSavedAddress {
    if (self.defaultBillingAddressIndex >= 0) {
        SavedAddress *savedAddress = [self.addresses objectAtIndex:self.defaultBillingAddressIndex];
        return savedAddress;
    } else {
        return nil;
    }

}

- (void)setShippingAddressIndex:(int)selectedIndex {
    self.defaultShippingAddressIndex = selectedIndex;
    SavedAddress *savedShippingAddress = [self.addresses objectAtIndex:selectedIndex];
    [[[ModelContext instance] plndrPurchaseSession] setPurchaseShippingAddress:savedShippingAddress.address];
}


- (void)setBillingAddressIndex:(int)selectedIndex {
    self.defaultBillingAddressIndex = selectedIndex;
    SavedAddress *savedBillingAddress = [self.addresses objectAtIndex:selectedIndex];
    [[[ModelContext instance] plndrPurchaseSession] setPurchaseBillingAddress:savedBillingAddress.address];
}
- (void)resetAddressBook {
    self.addresses = nil;
    self.defaultBillingAddressIndex = -1;
    self.defaultShippingAddressIndex = -1;
}

@end
