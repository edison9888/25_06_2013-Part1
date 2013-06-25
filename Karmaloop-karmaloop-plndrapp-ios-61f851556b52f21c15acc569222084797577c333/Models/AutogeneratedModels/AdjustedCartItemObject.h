#import <Foundation/Foundation.h>
#import "JSONBase.h"

@interface AdjustedCartItemObject : JSONBase <NSCoding, NSCopying> {
@protected
        NSNumber *_adjustedPricePerUnit;
        NSString *_productName;
        NSNumber *_adjustedShippingPerUnit;
        NSArray *_excludedForm;
        NSNumber *_originalPricePerUnit;
        NSNumber *_originalShippingPerUnit;
        NSNumber *_quantity;
        NSNumber *_skuId;
        NSNumber *_taxPerUnit;
}

    @property (nonatomic, strong, readonly) NSNumber *adjustedPricePerUnit;
    @property (nonatomic, strong, readonly) NSString *productName;
    @property (nonatomic, strong, readonly) NSNumber *adjustedShippingPerUnit;
    @property (nonatomic, strong, readonly) NSArray *excludedForm;
    @property (nonatomic, strong, readonly) NSNumber *originalPricePerUnit;
    @property (nonatomic, strong, readonly) NSNumber *originalShippingPerUnit;
    @property (nonatomic, strong, readonly) NSNumber *quantity;
    @property (nonatomic, strong, readonly) NSNumber *skuId;
    @property (nonatomic, strong, readonly) NSNumber *taxPerUnit;


- (id)initWithadjustedPricePerUnit:(NSNumber *)adjustedPricePerUnit
    productName:(NSString *)productName
    adjustedShippingPerUnit:(NSNumber *)adjustedShippingPerUnit
    excludedForm:(NSArray *)excludedForm
    originalPricePerUnit:(NSNumber *)originalPricePerUnit
    originalShippingPerUnit:(NSNumber *)originalShippingPerUnit
    quantity:(NSNumber *)quantity
    skuId:(NSNumber *)skuId
    taxPerUnit:(NSNumber *)taxPerUnit
;


@end