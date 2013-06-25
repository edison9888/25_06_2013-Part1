#import <Foundation/Foundation.h>
#import "JSONBase.h"

@interface SaleFilterSizeObject : JSONBase <NSCoding, NSCopying> {
@protected
        NSString *_displayName;
        NSString *_value;
}

    @property (nonatomic, strong, readonly) NSString *displayName;
    @property (nonatomic, strong, readonly) NSString *value;


- (id)initWithdisplayName:(NSString *)displayName
    value:(NSString *)value
;


@end