//
//  LoginSession.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AccountDetails, SavedAddress;

@interface LoginSession : NSObject <NSCoding>

@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) NSString* authToken;
@property (nonatomic, strong) NSMutableArray* addresses;
@property (nonatomic, strong) NSDate *lastTimeSavedAddressesWereFetched;
@property int defaultShippingAddressIndex;
@property int defaultBillingAddressIndex;

@property (readonly) BOOL isLoggedIn;
@property (nonatomic, strong) AccountDetails *accountDetails;

- (void) logout;
- (SavedAddress*) getBillingSavedAddress;
- (SavedAddress*) getShippingSavedAddress;
- (void) setShippingAddressIndex:(int) selectedIndex;
- (void) setBillingAddressIndex:(int) selectedIndex;
- (void) resetAddressBook;

@end
