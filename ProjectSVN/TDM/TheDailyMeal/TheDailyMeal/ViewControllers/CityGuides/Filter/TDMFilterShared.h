//
//  TDMFilterShared.h
//  TheDailyMeal
//
//  Created by Apple on 29/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol TDMFilterSharedDelegate <NSObject>
@required
-(void) gotFilterCriteria;
@end
@interface TDMFilterShared : NSObject{
    NSString *guideName;
    BOOL isARestaurant;
    BOOL isCriteriaSearch;
    NSString *criteriaCountry;
    id <TDMFilterSharedDelegate> filterdelegate;
}
@property (nonatomic, retain) id <TDMFilterSharedDelegate> filterdelegate;
@property (nonatomic, retain) NSString *guideName;
@property (nonatomic, retain) NSString *criteriaCountry;
@property (nonatomic) BOOL isARestaurant;
@property (nonatomic) BOOL isCriteriaSearch;
+(TDMFilterShared *)sharedFilterDetails;
-(void)initializeFilter:(NSString *)incomingFilterText;
@end
