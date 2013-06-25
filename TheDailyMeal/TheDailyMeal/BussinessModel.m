//
//  BussinessModel.m
//  TheDailyMeal
//
//  Created by Jayahari V - Rapid Value Solutions on 19/03/12.
//  Copyright (c) 2012 Apollo Group Inc. All rights reserved.
//

#import "BussinessModel.h"

@implementation BussinessModel

@synthesize venueId;
@synthesize fourSquareId;
@synthesize contactPhone;
@synthesize contactFormattedPhone;
@synthesize locationAddress;
@synthesize locationStreet;
@synthesize locationLatitude;
@synthesize locationLongitude;
@synthesize locationDistance;
@synthesize locationPostalCode;
@synthesize locationCity;
@synthesize locationState;
@synthesize locationCountry;
@synthesize categoryName;
@synthesize url;
@synthesize name;
@synthesize type;
@synthesize categoryImages;
@synthesize defaultCategoryImages;
@synthesize imageURL;
@synthesize categoryIcons;
@synthesize categoryID;
@synthesize categoryImagesFetched;
@synthesize parent;


-(id) init
{
    if (self = [super init]) 
    {
        self.venueId = [NSNumber numberWithInt:-1];
        self.fourSquareId = @"";
        self.contactPhone = @"";
        self.contactFormattedPhone = @"";
        self.locationAddress = @"";
        self.locationStreet = @"";
        self.locationLatitude = @"";
        self.locationLongitude = @"";
        self.locationDistance = @"";
        self.locationPostalCode = @"";
        self.locationCity = @"";
        self.locationState = @"";
        self.locationCountry = @"";
        self.categoryName = @"";
        self.url = @"";
        self.name = @"";
        self.type = [NSNumber numberWithInt:-1];
        self.imageURL = @"";
        self.categoryIcons = nil;
        self.categoryImages = nil;
        self.categoryID = nil;
    }
    return self;
}

- (BussinessModel *)initWithJson:(NSDictionary *)dictionary {
    
    if (self = [super init]) 
    {        
        self.fourSquareId = [dictionary objectForKey:@"id"];
        self.name = [dictionary objectForKey:@"name"];
        if ([[dictionary objectForKey:@"contact"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *contact = [dictionary objectForKey:@"contact"]; 
            if([[contact objectForKey:@"phone"] isKindOfClass:NSClassFromString(@"NSString")]) {
                self.contactPhone = [contact objectForKey:@"phone"];
            }
            if([[contact objectForKey:@"formattedPhone"] isKindOfClass:NSClassFromString(@"NSString")]) {
                self.contactFormattedPhone = [contact objectForKey:@"formattedPhone"];
            }
        }
        if ([[dictionary objectForKey:@"location"] isKindOfClass:[NSMutableDictionary class]]) {                    
            NSMutableDictionary *location = [dictionary objectForKey:@"location"];
            if([[location objectForKey:@"address"] isKindOfClass:NSClassFromString(@"NSString")]) {
                self.locationAddress = [location objectForKey:@"address"] ;
            }
            else
            {
                self.locationAddress = @"";
            }
            self.locationLatitude = [location objectForKey:@"lat"];
            self.locationLongitude = [location objectForKey:@"lng"];
            if([[location objectForKey:@"postalCode"] isKindOfClass:NSClassFromString(@"NSString")]) {
                self.locationPostalCode = [location objectForKey:@"postalCode"] ;
            }
            else
            {
                self.locationPostalCode = @"";
            }
            if([[location objectForKey:@"city"] isKindOfClass:NSClassFromString(@"NSString")]) {
                self.locationCity = [location objectForKey:@"city"];
            }
            else
            {
                self.locationCity = @"";
            }
            if([[location objectForKey:@"state"] isKindOfClass:NSClassFromString(@"NSString")]) {
                self.locationState = [location objectForKey:@"state"];
            }
            else
            {
                self.locationState = @"";
            }
            if([[location objectForKey:@"country"] isKindOfClass:NSClassFromString(@"NSString")]) {
                self.locationCountry = [location objectForKey:@"country"];
            }
            else
            {
                self.locationCountry = @"";
            }
            if([location objectForKey:@"distance"] != nil && [NSNull  null] != (NSNull *)[location objectForKey:@"distance"]) {
                double distance = [[location objectForKey:@"distance"] doubleValue];
                
                self.locationDistance = [NSString stringWithFormat:@"%0.2f",distance*0.000621371192];
            }
            else
            {
                self.locationDistance = @"";
            }
        }

        if ([[dictionary objectForKey:@"categories"] isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray *categoryArray = [dictionary objectForKey:@"categories"];
            if([categoryArray count]>=1) {
                NSDictionary *categoryDictionary = [categoryArray objectAtIndex:0];
                if([[categoryDictionary objectForKey:@"name"] isKindOfClass:NSClassFromString(@"NSString")]) {
                    self.categoryName = [categoryDictionary objectForKey:@"name"];
                }
                else {
                    self.categoryName = @"";
                }
                if([[categoryDictionary objectForKey:@"id"] isKindOfClass:NSClassFromString(@"NSString")]) {
                    self.categoryID = [categoryDictionary objectForKey:@"id"];
                }
                self.parent = [categoryDictionary objectForKey:@"parents"];
                NSDictionary *catergoryIcons = nil;
                if ([categoryDictionary objectForKey:@"icon"] != nil) {
                    catergoryIcons = [categoryDictionary objectForKey:@"icon"];
                }
                self.categoryIcons = catergoryIcons;
            }
        }
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
