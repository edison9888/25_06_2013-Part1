#import <Foundation/Foundation.h>
#import "JSONBase.h"

@interface CheckoutCompleteResponseObject : JSONBase <NSCoding, NSCopying> {
@protected
        NSNumber *_orderNumber;
}

    @property (nonatomic, strong, readonly) NSNumber *orderNumber;


- (id)initWithorderNumber:(NSNumber *)orderNumber
;


@end