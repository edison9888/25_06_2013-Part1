//
//  CreateSavedAddressSubscription.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateSavedAddressSubscription.h"
#import "Utility.h"
#import "ModelContext.h"

@implementation CreateSavedAddressSubscription

@synthesize address = _address;
@synthesize name =_name;
@synthesize isPrimary = _isPrimary;
@synthesize type = _type;

- (id)initWithAddress:(Address *)address withName:(NSString *)name isPrimary:(NSNumber *)isPrimary WithType:(SavedAddressTypes)type withContext:(ModelContext *)context {
    self.address = address;
    self.name = name;
    self.isPrimary  = isPrimary;
    self.type = type;
    self = [super initWithContext:context];
    return self;
}


- (BOOL)isDataAvailable {
    return NO;
}

- (BOOL)subscriptionMatches:(ModelSubscription *)subscription {
    return [subscription isKindOfClass:[self class]] 
        && [self.address isEqual:((CreateSavedAddressSubscription*)subscription).address]
        && [self.name isEqualToString:((CreateSavedAddressSubscription*)subscription).name]
        && [Utility isEqualNumber:self.isPrimary number2:((CreateSavedAddressSubscription*)subscription).isPrimary]
        && self.type == ((CreateSavedAddressSubscription*)subscription).type;
        
}

- (APIRequestController *)apiRequest {
    
    if (!self.isPrimary) {
        _isPrimary = [NSNumber numberWithBool:NO];
    }
    
    
    return [[APIRequestManager sharedInstance] postCreateSavedAddressesWithAddress:self.address name:self.name isPrimary:self.isPrimary type:[SavedAddress getSavedAddressTypeString:self.type] delegate:self.context];
}

@end

