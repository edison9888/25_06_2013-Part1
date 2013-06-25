//
//  ShareViewController.h
//  TheDailyMeal
//
//  Created by Jai Raj on 20/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ShareViewController : TDMBaseViewController <MFMailComposeViewControllerDelegate,UIActionSheetDelegate> {
    
    id parentController;
     NSString *urlString;

}
@property (nonatomic, retain) id parentController;
@property (nonatomic, retain) NSString* restauraName;
@property (nonatomic, retain) NSString* restauraAddress;
@property (nonatomic, retain) NSString* restauraCategory;
@property (nonatomic, retain) NSString *shareBody;
@property (nonatomic, retain) NSString *twitterBody;
@property (nonatomic, retain) UIImage *shareBodyImage;
@property (nonatomic, retain) NSString *imagePath;
@property (nonatomic, retain) NSString *dishName;
@property (nonatomic, retain) NSString *reviewText;
@property (nonatomic)  BOOL isFromReview;
@property (nonatomic) BOOL isFromAddDish;
@property(nonatomic)BOOL isFromBusinessHome;
@property(nonatomic)BOOL isFromBusinessDetail;
@property (nonatomic, retain) NSString *reviewBody;
@property (nonatomic, retain) NSString *addDishBody;
@property (nonatomic,retain)NSData *imageData;

//-(NSString*)getCurrentSystemTime;
//- (IBAction)onCancelButtonClick:(id)sender;
//- (IBAction)onFacebookButtonClick:(id)sender;
//- (IBAction)onTwitterButtonClick :(id)sender;
//- (IBAction)onMailButtonClick:(id)sender;

@end
