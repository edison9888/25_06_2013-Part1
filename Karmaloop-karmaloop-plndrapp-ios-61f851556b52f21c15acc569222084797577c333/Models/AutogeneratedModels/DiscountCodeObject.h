#import <Foundation/Foundation.h>
#import "JSONBase.h"

@interface DiscountCodeObject : JSONBase <NSCoding, NSCopying> {
@protected
        NSString *_name;
        NSString *_type;
}

    @property (nonatomic, strong, readwrite) NSString *name;
    @property (nonatomic, strong, readwrite) NSString *type;


- (id)initWithname:(NSString *)name
    type:(NSString *)type
;


@end