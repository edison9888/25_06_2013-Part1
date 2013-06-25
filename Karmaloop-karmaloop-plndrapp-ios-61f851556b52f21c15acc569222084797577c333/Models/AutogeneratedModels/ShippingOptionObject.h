#import <Foundation/Foundation.h>
#import "JSONBase.h"

@interface ShippingOptionObject : JSONBase <NSCoding, NSCopying> {
@protected
        NSNumber *_cost;
        NSString *_name;
        NSString *_shippingOptionValue;
}

    @property (nonatomic, strong, readonly) NSNumber *cost;
    @property (nonatomic, strong, readonly) NSString *name;
    @property (nonatomic, strong, readonly) NSString *shippingOptionValue;


- (id)initWithcost:(NSNumber *)cost
    name:(NSString *)name
    shippingOptionValue:(NSString *)shippingOptionValue
;


@end