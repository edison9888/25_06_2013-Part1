#import <Foundation/Foundation.h>
#import "JSONBase.h"
#import "SaleFilterSize.h"

@interface SaleFilterCategoryObject : JSONBase <NSCoding, NSCopying> {
@protected
        NSString *_displayName;
        NSString *_categoryId;
        NSArray *_sizes;
}

    @property (nonatomic, strong, readonly) NSString *displayName;
    @property (nonatomic, strong, readonly) NSString *categoryId;
    @property (nonatomic, strong, readonly) NSArray *sizes;


- (id)initWithdisplayName:(NSString *)displayName
    categoryId:(NSString *)categoryId
    sizes:(NSArray *)sizes
;


@end