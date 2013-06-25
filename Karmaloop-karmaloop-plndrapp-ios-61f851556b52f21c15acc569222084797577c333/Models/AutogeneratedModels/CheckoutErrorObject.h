#import <Foundation/Foundation.h>
#import "JSONBase.h"

@interface CheckoutErrorObject : JSONBase <NSCoding, NSCopying> {
@protected
        NSString *_affectedArea;
        NSString *_generalMessage;
        NSString *_itemMessage;
        NSNumber *_skuId;
        NSString *_errorCode;
}

    @property (nonatomic, strong, readonly) NSString *affectedArea;
    @property (nonatomic, strong, readonly) NSString *generalMessage;
    @property (nonatomic, strong, readonly) NSString *itemMessage;
    @property (nonatomic, strong, readonly) NSNumber *skuId;
    @property (nonatomic, strong, readonly) NSString *errorCode;


- (id)initWithaffectedArea:(NSString *)affectedArea
    generalMessage:(NSString *)generalMessage
    itemMessage:(NSString *)itemMessage
    skuId:(NSNumber *)skuId
    errorCode:(NSString *)errorCode
;


@end