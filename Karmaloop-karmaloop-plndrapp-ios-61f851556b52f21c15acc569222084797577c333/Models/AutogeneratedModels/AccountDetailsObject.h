#import <Foundation/Foundation.h>
#import "JSONBase.h"

@interface AccountDetailsObject : JSONBase <NSCoding, NSCopying> {
@protected
        NSString *_email;
        NSString *_firstName;
        NSString *_lastName;
        NSString *_phone;
        NSString *_birthdayRaw;
        NSString *_gender;
        NSNumber *_customerId;
}

    @property (nonatomic, strong, readwrite) NSString *email;
    @property (nonatomic, strong, readwrite) NSString *firstName;
    @property (nonatomic, strong, readwrite) NSString *lastName;
    @property (nonatomic, strong, readwrite) NSString *phone;
    @property (nonatomic, strong, readwrite) NSString *birthdayRaw;
    @property (nonatomic, strong, readwrite) NSString *gender;
    @property (nonatomic, strong, readwrite) NSNumber *customerId;


- (id)initWithemail:(NSString *)email
    firstName:(NSString *)firstName
    lastName:(NSString *)lastName
    phone:(NSString *)phone
    birthdayRaw:(NSString *)birthdayRaw
    gender:(NSString *)gender
    customerId:(NSNumber *)customerId
;


@end