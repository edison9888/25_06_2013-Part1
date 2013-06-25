//
//  TDMSignatureDishDetailsViewController.h
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/13/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDMAppDelegate.h"
#import "TDMBusinessDetailsProviderAndHandler.h"
#import "SignatureDish.h"

@interface TDMSignatureDishDetailsViewController : TDMBaseViewController<TDMLocationDelegate,NSURLConnectionDelegate,TDMBusinessDetailsProviderAndHandlerDelegate>{
    NSMutableData *responseData;
    
    NSMutableArray *dummyDetailsArray;
    
    NSString *selectedDishID;
        
}

@property (nonatomic, retain) NSString *selectedDishID;

@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UILabel *dishNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *dishByLabel;
@property (retain, nonatomic) IBOutlet UILabel *dishAuthorLabel;
@property (retain, nonatomic) IBOutlet UILabel *dishQuestonLabel;
@property (retain, nonatomic) IBOutlet UIButton *reviewButton;
@property (retain, nonatomic) IBOutlet UIButton *wishListButton;
@property (retain, nonatomic) IBOutlet UIButton *restaurantButton;
@property (retain, nonatomic) IBOutlet UIImageView *titleImageView;
@property (retain, nonatomic) IBOutlet UILabel *titleImageViewTitle;
@property (retain, nonatomic) IBOutlet UIButton *addButton;
@property (retain, nonatomic)   NSMutableData *responseData;

@property (nonatomic,retain) SignatureDish *signatureDish;

- (IBAction)addToFavButtonClick:(id)sender;
- (IBAction)addReviewButtonClick:(id)sender;
- (IBAction)goToRestBarButtonClick:(id)sender;
- (IBAction)addButtonClicked:(id)sender;

-(void)populateDummyData;

@end
