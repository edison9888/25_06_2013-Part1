#import <Foundation/Foundation.h>
#import "JSONBase.h"

@interface CreditCardTypeObject : JSONBase <NSCoding, NSCopying> {
@protected
        NSString *_name;
        NSString *_value;
}

    @property (nonatomic, strong, readonly) NSString *name;
    @property (nonatomic, strong, readonly) NSString *value;


- (id)initWithname:(NSString *)name
    value:(NSString *)value
;


@end