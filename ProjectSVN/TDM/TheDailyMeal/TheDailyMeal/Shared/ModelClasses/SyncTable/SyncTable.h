//
//  SyncTable.h
//  TheDailyMeal
//
//  Created by Anandlal on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SyncTable : NSManagedObject

@property (nonatomic, retain) NSString * lastModifiedDate;

@end
