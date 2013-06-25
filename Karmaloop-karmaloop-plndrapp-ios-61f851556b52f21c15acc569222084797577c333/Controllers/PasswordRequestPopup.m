//
//  PasswordRequestPopup.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PasswordRequestPopup.h"
#import "Constants.h"
#import "TextEntryPopupView.h"
#import "NotificationPopupView.h"
#import "PopupUtil.h"
#import "ModelContext.h"
#import "Utility.h"

@interface PasswordRequestPopup () 

- (void) notifyUserOfSuccess;
- (void) notifyUserOfFailure;
- (void) createForgotPasswordSubscription;
@end

@implementation PasswordRequestPopup

@synthesize email = _email, currentPopupView = _currentPopupView, forgotPasswordSubscription = _forgotPasswordSubscription;

#pragma mark - View lifecycle

- (void)dealloc {
    [self.forgotPasswordSubscription cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TextEntryPopupView *emailEntryView = [[TextEntryPopupView alloc] initWithTitle:kPasswordRequest instructions:@"To retrieve your password, please enter your email." errorMessage:@"An error occured. Please retry." textEntryDelegate:self];
    self.currentPopupView = emailEntryView;
    [self.view addSubview:self.currentPopupView];
    self.view.frame = emailEntryView.frame;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - private

- (void) notifyUserOfSuccess {
    
    NotificationPopupView *notificationView = [[NotificationPopupView alloc] initWithTitle:kPasswordRequest message:[NSString stringWithFormat: @"Please check your email at \"%@\" for instructions to recover your password.", self.email] popupViewDelegate:self];
    
    [PopupUtil transitionFromPopupView:self.currentPopupView toPopupView:notificationView];
    
    self.currentPopupView = notificationView;
}

- (void)notifyUserOfFailure {
    [((TextEntryPopupView*)self.currentPopupView) hideLoadingView];
    ((TextEntryPopupView*)self.currentPopupView).errorLabel.hidden = NO;
}

- (void)createForgotPasswordSubscription {
    [_forgotPasswordSubscription cancel]; //Cancel any previously set up subscription
    _forgotPasswordSubscription = [[ForgotPasswordSubscription alloc] initWithEmail:self.email context:[ModelContext instance]];
    _forgotPasswordSubscription.delegate = self;
    [self subscriptionUpdatedState:_forgotPasswordSubscription];
}

- (void) showLoadingView {
    [((TextEntryPopupView*)self.currentPopupView) showLoadingView];
}

- (void) hideLoadingView {
    [((TextEntryPopupView*)self.currentPopupView) hideLoadingView];
}


#pragma mark - TextEntryPopupViewDelegate

- (void) textEntryPopupView:(id)sender didEnterText:(NSString *)text {
    self.email = text;
}

- (void) textEntryPopupViewDidSubmit:(TextEntryPopupView *)sender {
    if (self.email.length > 0) {
        [self createForgotPasswordSubscription];
    } else {
        [self notifyUserOfFailure];
    }
    
}

#pragma mark - SubscriptionDelegate

- (void)subscriptionUpdatedState:(ModelSubscription *)subscription {
    if(subscription.state == SubscriptionStateNoConnection) {
        ((TextEntryPopupView*)self.currentPopupView).errorLabel.text = kPasswordRequestPopupConnectionErrorMessage;
        [self notifyUserOfFailure];
    } else if (subscription.state == SubscriptionStateAvailable) {
        [_forgotPasswordSubscription cancel];
        [self hideLoadingView];
        [self notifyUserOfSuccess];
    } else if (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable) {
        ((TextEntryPopupView*)self.currentPopupView).errorLabel.text = [Utility getDefaultErrorStringFromSubscription:self.forgotPasswordSubscription];
        [self notifyUserOfFailure];
    } else  { //Pending
        [self showLoadingView];
    }
}

@end
