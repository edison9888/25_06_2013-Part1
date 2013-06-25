//
//  TDMBusinessDetailsViewController.h
//  TheDailyMeal
//
//  Created by user on 18/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDMBusinessDetailsViewController : TDMBaseViewController
{
    NSMutableDictionary *dict;
    NSMutableArray *detailsArray;
}
@property (assign, nonatomic) int businessDetailId;
@property (retain, nonatomic) IBOutlet UIView *businessDetailView;
@property (retain, nonatomic) IBOutlet UILabel *businessNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessAddressLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessPhoneLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessCategoriesLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessWebsiteLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessNoteLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessHoursLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessAddressValueLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessPhoneValueLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessCategoriesValueLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessWebsiteValueLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessNoteValueLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessHoursValueLabel;
@property (retain, nonatomic) IBOutlet UIScrollView *businessDishScrollView;
@property (retain, nonatomic) IBOutlet UIView *businessReviewView;

- (void)initialiseDetails;
@end
