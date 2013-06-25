//
//  TDMReviewConfirmationViewController.h
//  TheDailyMeal
//
//  Created by Nithin George on 06/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface TDMReviewConfirmationViewController : TDMBaseViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
}

@property (retain, nonatomic) IBOutlet UIImageView *backGorudImageView;
@property (retain, nonatomic) IBOutlet UIImageView *viewTitleImageView;
@property (retain, nonatomic) IBOutlet UILabel *viewTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *reviewThanksLabel;
@property (retain, nonatomic) IBOutlet UILabel *reviewConfirmationLabel;
@property (retain, nonatomic) IBOutlet UIButton *adButton;


@property (retain, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (retain, nonatomic) IBOutlet UIButton *skipButton;


@property (retain, nonatomic) IBOutlet UIView *contentView;
- (IBAction)addPhotoButtonClicked:(id)sender;
- (IBAction)skipButtonClicked:(id)sender;
- (IBAction)adButtonClicked:(id)sender;

@end
