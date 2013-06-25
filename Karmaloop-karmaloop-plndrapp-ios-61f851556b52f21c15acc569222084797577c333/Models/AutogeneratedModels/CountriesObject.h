#import <Foundation/Foundation.h>
#import "JSONBase.h"
#import "State.h"

@interface CountriesObject : JSONBase <NSCoding, NSCopying> {
@protected
        NSString *_name;
        NSString *_shortName;
        NSArray *_states;
}

    @property (nonatomic, strong, readonly) NSString *name;
    @property (nonatomic, strong, readonly) NSString *shortName;
    @property (nonatomic, strong, readonly) NSArray *states;


- (id)initWithname:(NSString *)name
    shortName:(NSString *)shortName
    states:(NSArray *)states
;


@end