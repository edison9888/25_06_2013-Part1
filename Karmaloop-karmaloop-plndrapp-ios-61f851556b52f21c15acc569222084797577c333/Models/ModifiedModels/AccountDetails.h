//
//  AccountDetails.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountDetailsObject.h"

typedef enum {
    Unknown,
    Male,
    Female
}GenderType;

@interface AccountDetails : AccountDetailsObject

@property (nonatomic, strong) NSDate *birthday;

@end
