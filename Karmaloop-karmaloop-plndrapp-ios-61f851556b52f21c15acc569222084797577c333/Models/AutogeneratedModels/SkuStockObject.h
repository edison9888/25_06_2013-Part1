#import <Foundation/Foundation.h>
#import "JSONBase.h"

@interface SkuStockObject : JSONBase <NSCoding, NSCopying> {
@protected
        NSNumber *_skuId;
        NSNumber *_stock;
}

    @property (nonatomic, strong, readonly) NSNumber *skuId;
    @property (nonatomic, strong, readonly) NSNumber *stock;


- (id)initWithskuId:(NSNumber *)skuId
    stock:(NSNumber *)stock
;


@end