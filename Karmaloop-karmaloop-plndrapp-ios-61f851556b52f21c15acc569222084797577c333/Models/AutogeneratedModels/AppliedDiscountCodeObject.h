#import <Foundation/Foundation.h>
#import "JSONBase.h"

@interface AppliedDiscountCodeObject : JSONBase <NSCoding, NSCopying> {
@protected
        NSString *_name;
        NSString *_discountDescription;
        NSNumber *_shipping;
        NSNumber *_subtotal;
        NSNumber *_totalDiscount;
        NSString *_type;
}

    @property (nonatomic, strong, readwrite) NSString *name;
    @property (nonatomic, strong, readwrite) NSString *discountDescription;
    @property (nonatomic, strong, readwrite) NSNumber *shipping;
    @property (nonatomic, strong, readwrite) NSNumber *subtotal;
    @property (nonatomic, strong, readwrite) NSNumber *totalDiscount;
    @property (nonatomic, strong, readwrite) NSString *type;


- (id)initWithname:(NSString *)name
    discountDescription:(NSString *)discountDescription
    shipping:(NSNumber *)shipping
    subtotal:(NSNumber *)subtotal
    totalDiscount:(NSNumber *)totalDiscount
    type:(NSString *)type
;


@end