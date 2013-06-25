#import <Foundation/Foundation.h>
#import "JSONBase.h"

@interface SaleObject : JSONBase <NSCoding, NSCopying> {
@protected
        NSNumber *_saleId;
        NSString *_url;
        NSNumber *_vendorId;
        NSString *_name;
        NSString *_tileImagePathLarge;
        NSString *_tileImagePathMedium;
        NSString *_startDateRaw;
        NSString *_endDateRaw;
        NSNumber *_priority;
}

    @property (nonatomic, strong, readonly) NSNumber *saleId;
    @property (nonatomic, strong, readonly) NSString *url;
    @property (nonatomic, strong, readonly) NSNumber *vendorId;
    @property (nonatomic, strong, readonly) NSString *name;
    @property (nonatomic, strong, readonly) NSString *tileImagePathLarge;
    @property (nonatomic, strong, readonly) NSString *tileImagePathMedium;
    @property (nonatomic, strong, readonly) NSString *startDateRaw;
    @property (nonatomic, strong, readonly) NSString *endDateRaw;
    @property (nonatomic, strong, readonly) NSNumber *priority;


- (id)initWithsaleId:(NSNumber *)saleId
    url:(NSString *)url
    vendorId:(NSNumber *)vendorId
    name:(NSString *)name
    tileImagePathLarge:(NSString *)tileImagePathLarge
    tileImagePathMedium:(NSString *)tileImagePathMedium
    startDateRaw:(NSString *)startDateRaw
    endDateRaw:(NSString *)endDateRaw
    priority:(NSNumber *)priority
;


@end