//
//  SettingViewController.h
//  PE
//
//  Created by Nithin George on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SettingViewController : UIViewController <UIActionSheetDelegate,MFMailComposeViewControllerDelegate> {
    
}

- (void)createCustomNavigationLeftButton;
- (void)showActivitySheet;
- (void)loadShareTwitter;
- (void)loadShareFacebook;
- (void)loadResetView;
- (void)clearCache;
- (void)seetingMailBodyComponents:(NSString *)toAddress:(NSString *)subject:(NSString *)body;

- (IBAction)doneButtonClicked:(id)sender;

@end
