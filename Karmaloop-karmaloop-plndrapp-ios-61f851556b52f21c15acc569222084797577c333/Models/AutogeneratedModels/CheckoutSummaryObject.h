#import <Foundation/Foundation.h>
#import "JSONBase.h"
#import "AdjustedCartItem.h"
#import "AppliedDiscountCode.h"

@interface CheckoutSummaryObject : JSONBase <NSCoding, NSCopying> {
@protected
        NSArray *_adjustedItems;
        NSArray *_appliedDiscounts;
        NSNumber *_cartSubtotal;
        NSNumber *_handling;
        NSNumber *_shippingSubtotal;
        NSNumber *_subtotal;
        NSNumber *_tax;
        NSNumber *_total;
        NSNumber *_totalDiscount;
}

    @property (nonatomic, strong, readonly) NSArray *adjustedItems;
    @property (nonatomic, strong, readonly) NSArray *appliedDiscounts;
    @property (nonatomic, strong, readonly) NSNumber *cartSubtotal;
    @property (nonatomic, strong, readonly) NSNumber *handling;
    @property (nonatomic, strong, readonly) NSNumber *shippingSubtotal;
    @property (nonatomic, strong, readonly) NSNumber *subtotal;
    @property (nonatomic, strong, readonly) NSNumber *tax;
    @property (nonatomic, strong, readonly) NSNumber *total;
    @property (nonatomic, strong, readonly) NSNumber *totalDiscount;


- (id)initWithadjustedItems:(NSArray *)adjustedItems
    appliedDiscounts:(NSArray *)appliedDiscounts
    cartSubtotal:(NSNumber *)cartSubtotal
    handling:(NSNumber *)handling
    shippingSubtotal:(NSNumber *)shippingSubtotal
    subtotal:(NSNumber *)subtotal
    tax:(NSNumber *)tax
    total:(NSNumber *)total
    totalDiscount:(NSNumber *)totalDiscount
;


@end