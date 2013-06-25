//
//  BusinessResturantModelClass.m
//  TheDailyMeal
//
//  Created by Apple on 15/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BusinessResturantModelClass.h"

@implementation BusinessResturantModelClass

@synthesize fourSquareId;
@synthesize resturantName;
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

-(id) init
{
    if (self = [super init]) 
    {
        self.fourSquareId = @" ";
        self.resturantName  = @" ";
        self.contactPhone = @" ";
        self.contactFormattedPhone = @" ";
        self.locationAddress = @" ";
        self.locationStreet = @" ";
        self.locationLatitude = @" ";
        self.locationLongitude = @" ";
        self.locationDistance = @" ";
        self.locationPostalCode = @" ";
        self.locationCity = @" ";
        self.locationState = @" ";
        self.locationCountry = @" ";
        self.categoryName = @" ";
    }
    return self;
}
@end
