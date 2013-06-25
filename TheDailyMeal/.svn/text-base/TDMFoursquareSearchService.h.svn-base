//
//  TDMFoursquareSearchService.h
//  TheDailyMeal
//
//  Created by Apple on 26/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDMBaseHttpHandler.h"


typedef enum {
    SearchTypeBars = 0,
    SearchTypeRestaurant = 1,

} SearchType;

@protocol TDMFoursquareSearchServiceDelegate <NSObject>

-(void) searchSuccessfullWithResults:(NSMutableArray *)searchedItems;
-(void) failedToSearch;
-(void) requestTimeout;
- (void)networkError;
@end

@interface TDMFoursquareSearchService : TDMBaseHttpHandler {
    
    id<TDMFoursquareSearchServiceDelegate> searchDelegate;
    BOOL isAddressSearch;
    SearchType searchType;
}

@property (nonatomic, retain) id<TDMFoursquareSearchServiceDelegate> searchDelegate;
@property (nonatomic, retain) NSMutableArray *searchItems;
@property (nonatomic, retain) NSString *restaurantName;
- (void)searchForName:(NSString *)text withSearchType:(SearchType)searchType_;
- (void)searchForBrowseName:(NSString *)text;
- (void)searchForName:(NSString *)name withAddress:(NSString *)address withSearchType:(SearchType)searchType_;

@end
