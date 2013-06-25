//
//  TDMFavoritesViewController.h
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/3/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDMBusinessDetails.h"
#import "DatabaseManager.h"

@interface TDMFavoritesViewController : TDMBaseViewController{
    NSMutableArray *detailsArray;
}

@property (nonatomic, assign) int businessType;
@property (nonatomic, assign) int businessId;

- (void)initialize;
- (IBAction)backButtonAction:(id)sender;

@end
