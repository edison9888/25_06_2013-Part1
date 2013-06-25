//
//  CreditCardViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModalViewController.h"
#import "GetCreditCardOptionSubscription.h"
#import "PopupNotificationViewController.h"

typedef enum {
    CCSectionError,
    CCSectionCell,
    CCSectionNUM
}CCSectionTypes;


typedef enum {
    CCCellType,
    CCCellName,
    CCCellNumber,
    CCCellExpiry,
    CCCellCVV,
    CCCellNUM
} CCCell;

@interface CreditCardViewController : BaseModalViewController <SubscriptionDelegate>

@property (nonatomic, strong) NSArray *creditCardPickerValue;
@property (nonatomic, strong) NSString *creditCardName;
@property (nonatomic, strong) NSString *creditCardNumber;
@property (nonatomic, strong) NSArray *creditCardExpiry;
@property (nonatomic, strong) NSString *creditCardCVV;

@property (nonatomic, strong) GetCreditCardOptionSubscription *getCreditCardOptionSubscription;

@end
