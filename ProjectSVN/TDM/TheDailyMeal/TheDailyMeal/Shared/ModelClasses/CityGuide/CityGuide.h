//
//  CityGuide.h
//  TheDailyMeal
//
//  Created by Anandlal on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Business;

@interface CityGuide : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Business *newRelationship;

@end
