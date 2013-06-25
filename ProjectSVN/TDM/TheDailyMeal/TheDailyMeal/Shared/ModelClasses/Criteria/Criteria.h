//
//  Criteria.h
//  TheDailyMeal
//
//  Created by Anandlal on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Business;

@interface Criteria : NSManagedObject

@property (nonatomic, retain) NSNumber * businessId;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Business *criteriaRelationNew;

@end
