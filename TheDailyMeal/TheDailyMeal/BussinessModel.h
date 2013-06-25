//
//  BussinessModel.h
//  TheDailyMeal
//
//  Created by Jayahari V - Rapid Value Solutions on 19/03/12.
//  Copyright (c) 2012 Apollo Group Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BussinessModel : NSObject

@property (nonatomic, strong) NSNumber *venueId;
@property (nonatomic, strong) NSString *fourSquareId;
@property (nonatomic, strong) NSString *contactPhone;
@property (nonatomic, strong) NSString *contactFormattedPhone;
@property (nonatomic, strong) NSString *locationAddress;
@property (nonatomic, strong) NSString *locationStreet;
@property (nonatomic, strong) NSString *locationLatitude;
@property (nonatomic, strong) NSString *locationLongitude;
@property (nonatomic, strong) NSString *locationDistance;
@property (nonatomic, strong) NSString *locationPostalCode;
@property (nonatomic, strong) NSString *locationCity;
@property (nonatomic, strong) NSString *locationState;
@property (nonatomic, strong) NSString *locationCountry;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *categoryID;
@property (nonatomic, strong) NSDictionary *categoryIcons;
@property (nonatomic, strong) NSMutableArray *categoryImages;
@property (nonatomic, strong) NSMutableArray *defaultCategoryImages;
@property (nonatomic,assign) BOOL categoryImagesFetched;

@property (nonatomic, strong) NSArray *parent;

- (BussinessModel *)initWithJson:(NSDictionary *)dictionary;

@end
