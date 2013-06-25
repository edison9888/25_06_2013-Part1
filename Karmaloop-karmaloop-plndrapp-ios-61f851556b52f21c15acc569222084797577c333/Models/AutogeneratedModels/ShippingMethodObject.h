#import <Foundation/Foundation.h>
#import "JSONBase.h"
#import "ShippingOption.h"

@interface ShippingMethodObject : JSONBase <NSCoding, NSCopying> {
@protected
        NSNumber *_cost;
        NSNumber *_isAvailable;
        NSString *_name;
        NSString *_shippingMethodValue;
        NSArray *_shippingOptions;
}

    @property (nonatomic, strong, readonly) NSNumber *cost;
    @property (nonatomic, strong, readonly) NSNumber *isAvailable;
    @property (nonatomic, strong, readonly) NSString *name;
    @property (nonatomic, strong, readonly) NSString *shippingMethodValue;
    @property (nonatomic, strong, readonly) NSArray *shippingOptions;


- (id)initWithcost:(NSNumber *)cost
    isAvailable:(NSNumber *)isAvailable
    name:(NSString *)name
    shippingMethodValue:(NSString *)shippingMethodValue
    shippingOptions:(NSArray *)shippingOptions
;


@end