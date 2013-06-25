//
//  TDMAddSignatureDishThanks.h
//  TheDailyMeal
//
//  Created by Apple on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareViewController.h"
#import "FBConnect.h"

@interface TDMAddSignatureDishThanks : TDMBaseViewController<MFMailComposeViewControllerDelegate,FBDialogDelegate,FBSessionDelegate>
{
    ShareViewController *shareViewController;
     Facebook *facebook;
   }
@property (retain, nonatomic) IBOutlet UIButton *shareButton;
@property (nonatomic, assign)BOOL isFromBusinessHome;
@property (retain, nonatomic) NSString *facebookShareContent;
@property (nonatomic, retain)NSString *dishName;
@property (nonatomic, retain)NSString *dishCategory;
@property (nonatomic, retain)NSString *dishImage;
@property (nonatomic, retain)NSString *restaurantName;
@property (nonatomic, retain) NSData *imageData;
@property(nonatomic)BOOL isAddDishShare;

@property (assign) BOOL isFromShare;
-(IBAction) shareButtonClick:(id)sender;
@end
