#import <Foundation/Foundation.h>
#import "JSONBase.h"

@interface StateObject : JSONBase <NSCoding, NSCopying> {
@protected
        NSString *_name;
        NSString *_shortName;
}

    @property (nonatomic, strong, readonly) NSString *name;
    @property (nonatomic, strong, readonly) NSString *shortName;


- (id)initWithname:(NSString *)name
    shortName:(NSString *)shortName
;


@end