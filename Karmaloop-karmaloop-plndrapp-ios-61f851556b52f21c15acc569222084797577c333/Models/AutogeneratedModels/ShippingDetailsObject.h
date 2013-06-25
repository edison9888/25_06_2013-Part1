#import <Foundation/Foundation.h>
#import "JSONBase.h"
#import "Address.h"

@interface ShippingDetailsObject : JSONBase <NSCoding, NSCopying> {
@protected
        Address *_address;
        NSString *_method;
        NSArray *_options;
}

    @property (nonatomic, strong, readwrite) Address *address;
    @property (nonatomic, strong, readwrite) NSString *method;
    @property (nonatomic, strong, readwrite) NSArray *options;


- (id)initWithaddress:(Address *)address
    method:(NSString *)method
    options:(NSArray *)options
;


@end