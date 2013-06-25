//
//  PurchaseReceiptViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseModalViewController.h"

typedef enum{
    PurchaseConfirmationMoneySection,
    PurchaseConfirmationInformationSection
}PurchaseConfirmationSections;

typedef enum{
    PurchaseConfirmationShippingCell,
    PurchaseConfirmationOrderNumberCell
}PurchaseConfirmationInformationSectionCell;



@interface PurchaseReceiptViewController : BaseModalViewController


@end
