//
//  TDMBaseViewController.h
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/4/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLParser.h"
#import "JSONHandler.h"
#import "TDMBusinessService.h"

@interface TDMBaseViewController : UIViewController<JsonParserDelegate,parseData,UIWebViewDelegate> {
    
    id delegate;
}

#pragma mark ViewCreations
- (void)hideTabbar;
- (void)showTabbar;
- (void)createAccountButtonOnNavBar;
- (void)createReviewListButtonOnNavBar;
- (void)createNavigationBarButtonOfType:(int)aButtonType;
- (void)createCustomisedNavigationTitleWithString:(NSString *)titleString;
- (void)createAdView; 
- (void)createRefreshButtonOnNavBarForViewController;
- (void)disableBackButton:(BOOL)value;
//Channel Parsing
- (void)parseChannelsContents;

#pragma mark Button Actions
- (void)accountBarButtonClicked:(id)sender;

#pragma mark Helpers
- (UIViewController *)getClass:(NSString *)aClassName;

//added By Bittu
- (void)sendRequestToAddDishWithDictionary:(NSMutableDictionary *)dict;


@end
