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

@interface TDMBaseViewController : UIViewController<JsonParserDelegate>{
    
    id delegate;
}

#pragma mark ViewCreations
- (void)hideTabbar;
- (void)showTabbar;
- (void)createAccountButtonOnNavBar;
- (void)createAddReviewButtonOnNavBar;
- (void)createNavigationBarButtonOfType:(int)aButtonType;
- (void)createCustomisedNavigationTitleWithString:(NSString *)titleString;
- (void)userlogin:(NSString *)userName password:(NSString *)password;

//Channel Parsing
- (void)parseChannelsContents;

#pragma mark Button Actions
- (void)accountBarButtonClicked:(id)sender;

#pragma mark Helpers
- (UIViewController *)getClass:(NSString *)aClassName;

#pragma mark - Database Helpers
- (NSMutableArray *)getBusinessFromDatabaseWithType:(NSString *)busType;
@end
