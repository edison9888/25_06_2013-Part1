//
//  DisplayMap.h
//  TheDailyMeal
//
//  Created by Bittu Davis on 11/22/11.
//  Copyright (c) 2011 RapidValue Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface DisplayMap : NSObject <MKAnnotation> {
    
	CLLocationCoordinate2D coordinate; 
	NSString *title; 
	NSString *subtitle;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate; 
@property (nonatomic, copy) NSString *title; 
@property (nonatomic, copy) NSString *subtitle;

@end
