//
//  PopupNotificationViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PopupNotificationViewController.h"
#import "NotificationPopupView.h"
#import "TwoButtonNotificationPopupView.h"
#import "OneButtonNotificationPopupView.h"

@implementation PopupNotificationViewController

@synthesize  notificationTitle = _notificationTitle, notificationMessage = _notificationMessage;
@synthesize buttonOneTitle = _buttonOneTitle;
@synthesize buttonTwoTitle = _buttonTwoTitle;

- (id)initWithTitle:(NSString *)title message:(NSString *)message{
    self = [super init];
    if (self) {
        self.notificationTitle = title;
        self.notificationMessage = message;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message buttonOneTitle:(NSString *)buttonOneTitle {
    self = [super init];
    if (self) {
        self.notificationTitle = title;
        self.notificationMessage = message;
        self.buttonOneTitle = buttonOneTitle;
    }
    return  self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message buttonOneTitle:(NSString *)buttonOneTitle buttonTwoTitle:(NSString *)buttonTwoTitle {
    self = [super init];
    if (self) {
        self.notificationTitle = title;
        self.notificationMessage = message;
        self.buttonOneTitle = buttonOneTitle;
        self.buttonTwoTitle = buttonTwoTitle;
    }
    return  self;
}

- (int) numberOfButtons {
    if (self.buttonTwoTitle.length > 0) {
        return 2;
    } else {
        return 1;
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PopupView *notificationView = nil;
    if (!self.buttonOneTitle.length > 0) {
        notificationView = [[NotificationPopupView alloc] initWithTitle:self.notificationTitle message:self.notificationMessage popupViewDelegate:self];
    } else if(!self.buttonTwoTitle.length > 0) {
        notificationView = [[OneButtonNotificationPopupView alloc] initWithTitle:self.notificationTitle withMessage:self.notificationMessage withButtonOneTitle:self.buttonOneTitle withPopupViewDelegate:self];
    } else {
        notificationView = [[TwoButtonNotificationPopupView alloc] initWithTitle:self.notificationTitle withMessage:self.notificationMessage withButtonOneTitle:self.buttonOneTitle withButtonTwoTitle:self.buttonTwoTitle withPopupViewDelegate:self];
    }
    
    [self.view addSubview:notificationView];
    self.view.frame = notificationView.frame;
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

#pragma mark - PopupViewDelegate

- (void)popupViewDelegateOneButtonClicked:(id)sender {
    [self.popupDelegate popupButtonOneClicked:sender popupViewController:self];
}

- (void)popupViewDelegateTwoButtonClicked:(id)sender {
    [self.popupDelegate popupButtonTwoClicked:sender popupViewController:self];
}

@end
