//
//  DiscountViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseModalViewController.h"
#import "CheckoutSummarySubscription.h"
#import "PopupViewController.h"
#import "PopupNotificationViewController.h"

@class DiscountCode, CheckoutError;

typedef enum {
    DiscountSectionError,
    DiscountSectionPromotions,
    DiscountSectionGiftCertificates,
    DiscountSectionNUM
}DiscountSections;

typedef enum{
    DiscountErrorCell,
    DiscountErrorNUM
}DiscountErrorSectionCell;

typedef enum{
    DiscountPromotionPromoCell,
    DiscountPromotionRepCell,
    DiscountPromotionsNUM
}DiscountPromotionsSectionCell;

typedef enum{
    DiscountGiftCertificateCell,
    DiscountGiftCertificateNUM
}DiscountGiftCertificateSectionCell;

@interface DiscountViewController : BaseModalViewController <SubscriptionDelegate>


@property (nonatomic, strong) DiscountCode *promoCode;
@property (nonatomic, strong) DiscountCode *repCode;
@property (nonatomic, strong) NSMutableArray *giftCodes;

@property (nonatomic, strong) CheckoutSummarySubscription *checkoutSummarySubscription;
@property (nonatomic, strong) CheckoutError *mostImportantError;
@property (nonatomic, strong) PopupViewController *checkoutErrorPopup;
@end
