//
//  TDMSignatureDishDetailsViewController.h
//  TheDailyMeal
//
//  Created by Nibin V on 24/03/2012.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDMSignatureDishModel.h"
#import "TDMAsyncImage.h"
#import <QuartzCore/QuartzCore.h>
#import "SignatureDishModel.h"

@interface TDMSignatureDishDetailsViewController : TDMBaseViewController<UIWebViewDelegate>
{
    TDMSignatureDishModel *signatureDishModel;        
}
@property (retain, nonatomic) IBOutlet UIImageView *dishImageView;

@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIButton *restaurantButton;
@property (retain, nonatomic) IBOutlet UIButton *dishImageButton;
@property (retain, nonatomic) IBOutlet UILabel *dishNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *reviewAuthorName;
@property (retain, nonatomic) IBOutlet UIWebView *reviewDescriptionWebView;
@property (retain, nonatomic) IBOutlet UIView *mainDetailsView;
@property (retain, nonatomic) IBOutlet UIView *shareThoughtsBGView;
@property (retain, nonatomic) IBOutlet UIView *reviewBGView;
@property (retain, nonatomic) IBOutlet UIButton *shareYourThoughtButton;
@property (retain, nonatomic) IBOutlet UIButton *addToWishList;
@property (retain, nonatomic) IBOutlet UILabel *atLabel;

@property (retain, nonatomic) TDMAsyncImage *reviewAuthorImage;
@property (retain, nonatomic) TDMSignatureDishModel *signatureDishModel;
@property (retain, nonatomic) IBOutlet UILabel *navigationBarTitle;

- (void)addBusinessToWishList;
- (IBAction)onClickGoToRestaurant:(id)sender;

@end
