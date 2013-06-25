//
//  InfoPage.h
//  Red Beacon
//
//  Created by Runi Kovoor on 16/08/11.
//  Copyright 2011 Rapid Value Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBLoginHandler.h"
#import "RBBaseHttpHandler.h"
#import "RBDefaultsWrapper.h"
#import "RBLoadingOverlay.h"

@interface InfoPage : UIViewController<RBBaseHttpHandlerDelegate>
{
    UIButton * loginOrLogoutButton;
    RBLoginHandler * loginHandler;
    RBLoadingOverlay * overlay;
    UILabel * loginLogoutStatusLabel;
    UILabel * usernameLabel;
}

@property (nonatomic, retain) IBOutlet UIButton *loginOrLogoutButton;
@property (nonatomic, retain) RBLoadingOverlay * overlay;
@property (nonatomic, retain) IBOutlet UILabel * loginLogoutStatusLabel;
@property (nonatomic, retain) IBOutlet UILabel * usernameLabel;

+ (NSString*)getNibName;
- (void)setupNavigationBar;
- (IBAction)onTouchUpLoginOrLogout:(id)sender;
- (IBAction)onTouchUpCancel:(id)sender;
- (IBAction)onTouchUpClose:(id)sender;

@end
