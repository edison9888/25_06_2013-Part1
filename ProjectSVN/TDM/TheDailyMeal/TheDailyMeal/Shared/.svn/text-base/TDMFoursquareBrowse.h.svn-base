//
//  TDMFoursquareBrowse.h
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMBaseHttpHandler.h"
@protocol TDMFoursquareBrowseDelegate<NSObject>
-(void) criteriaSearchFinishedSuccessfully;
-(void) criteriaSearchNoResult;
-(void) criteriaSearchFailed;
@end

@interface TDMFoursquareBrowse : TDMBaseHttpHandler
{
    id <TDMFoursquareBrowseDelegate> foursquareBrowseDelgate;
}
@property (nonatomic, retain) id <TDMFoursquareBrowseDelegate> foursquareBrowseDelgate;
@end
