//
//  Business.h
//  TheDailyMeal
//
//  Created by Anandlal on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Business : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * businessId;
@property (nonatomic, retain) NSNumber * cheap;
@property (nonatomic, retain) NSNumber * cityId;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSNumber * hotList;
@property (nonatomic, retain) NSString * logoImage;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSNumber * restaurant101;
@property (nonatomic, retain) NSNumber * reviewCount;
@property (nonatomic, retain) NSNumber * topRestaurant;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSManagedObject *cityGuideRelation;
@property (nonatomic, retain) NSManagedObject *criteriaRelation;
@property (nonatomic, retain) NSManagedObject *reviewRelation;
@property (nonatomic, retain) NSManagedObject *signatureDishRelation;

@end
