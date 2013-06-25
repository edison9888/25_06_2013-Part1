#import <Foundation/Foundation.h>
#import "JSONBase.h"

@interface ProductSkuObject : JSONBase <NSCoding, NSCopying> {
@protected
        NSNumber *_skuId;
        NSNumber *_stock;
        NSString *_size;
        NSString *_color;
}

    @property (nonatomic, strong, readonly) NSNumber *skuId;
    @property (nonatomic, strong, readonly) NSNumber *stock;
    @property (nonatomic, strong, readonly) NSString *size;
    @property (nonatomic, strong, readonly) NSString *color;


- (id)initWithskuId:(NSNumber *)skuId
    stock:(NSNumber *)stock
    size:(NSString *)size
    color:(NSString *)color
;


@end