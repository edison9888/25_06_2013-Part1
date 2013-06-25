#import <Foundation/Foundation.h>
#import "JSONBase.h"
#import "ProductSku.h"

@interface ProductObject : JSONBase <NSCoding, NSCopying> {
@protected
        NSNumber *_productId;
        NSString *_style;
        NSString *_name;
        NSString *_url;
        NSString *_productDescription;
        NSNumber *_vendorId;
        NSString *_vendorName;
        NSString *_availabilityEndDateRaw;
        NSString *_browseImageUrl;
        NSNumber *_checkoutPrice;
        NSNumber *_price;
        NSNumber *_categoryId;
        NSArray *_zooms;
        NSNumber *_stock;
        NSArray *_skus;
}

    @property (nonatomic, strong, readonly) NSNumber *productId;
    @property (nonatomic, strong, readonly) NSString *style;
    @property (nonatomic, strong, readonly) NSString *name;
    @property (nonatomic, strong, readonly) NSString *url;
    @property (nonatomic, strong, readonly) NSString *productDescription;
    @property (nonatomic, strong, readonly) NSNumber *vendorId;
    @property (nonatomic, strong, readonly) NSString *vendorName;
    @property (nonatomic, strong, readonly) NSString *availabilityEndDateRaw;
    @property (nonatomic, strong, readonly) NSString *browseImageUrl;
    @property (nonatomic, strong, readonly) NSNumber *checkoutPrice;
    @property (nonatomic, strong, readonly) NSNumber *price;
    @property (nonatomic, strong, readonly) NSNumber *categoryId;
    @property (nonatomic, strong, readonly) NSArray *zooms;
    @property (nonatomic, strong, readonly) NSNumber *stock;
    @property (nonatomic, strong, readonly) NSArray *skus;


- (id)initWithproductId:(NSNumber *)productId
    style:(NSString *)style
    name:(NSString *)name
    url:(NSString *)url
    productDescription:(NSString *)productDescription
    vendorId:(NSNumber *)vendorId
    vendorName:(NSString *)vendorName
    availabilityEndDateRaw:(NSString *)availabilityEndDateRaw
    browseImageUrl:(NSString *)browseImageUrl
    checkoutPrice:(NSNumber *)checkoutPrice
    price:(NSNumber *)price
    categoryId:(NSNumber *)categoryId
    zooms:(NSArray *)zooms
    stock:(NSNumber *)stock
    skus:(NSArray *)skus
;


@end