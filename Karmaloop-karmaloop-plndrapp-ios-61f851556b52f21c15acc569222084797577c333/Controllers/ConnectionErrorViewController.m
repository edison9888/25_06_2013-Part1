//
//  ConnectionErrorViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-07-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConnectionErrorViewController.h"
#import "GANTracker.h"
#import "Constants.h"
#import "Utility.h"

@interface ConnectionErrorViewController ()

- (void)refreshButtonClicked:(id)sender;
- (void)refreshConnectionNetwork;

@end

@implementation ConnectionErrorViewController

@synthesize noticeImageView = _noticeImageView;

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"";
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    }
    return self;
}

- (void) viewDidUnload {
    [super viewDidUnload];
    
    self.noticeImageView = nil;
}

- (void) loadView {
    self.view = [[UIView alloc] initWithFrame:[self defaultFrame]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];    

    self.view.backgroundColor = kPlndrBgGrey;
    
    UIImage *noticeImage = [UIImage imageNamed:@"notice_icon.png"];
    self.noticeImageView = [[UIImageView alloc] initWithImage:noticeImage];
    self.noticeImageView.frame = CGRectMake((kDeviceWidth - noticeImage.size.width)/2, 30, noticeImage.size.width, noticeImage.size.height);
    [self.view addSubview:self.noticeImageView];
    
    UILabel *noNetworkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.noticeImageView.frame.origin.y + self.noticeImageView.frame.size.height + 1.25*kConnectionErrorVerticalPadding, kDeviceWidth, 20)];
    noNetworkLabel.text = kConnectionErrorNoConnectionMessage;
    noNetworkLabel.backgroundColor = [UIColor clearColor];
    noNetworkLabel.font = kFontBoldCond20;
    noNetworkLabel.textAlignment = UITextAlignmentCenter;
    noNetworkLabel.textColor = kPlndrBlack;
    [self.view addSubview:noNetworkLabel];
    
    UILabel *noNetworkInstruction = [[UILabel alloc] initWithFrame:CGRectMake(0, noNetworkLabel.frame.origin.y + noNetworkLabel.frame.size.height + kConnectionErrorVerticalPadding, kDeviceWidth, 20)];
    noNetworkInstruction.text = kConnectionErrorAssistanceMessage;
    noNetworkInstruction.backgroundColor = [UIColor clearColor];
    noNetworkInstruction.font = kFontMediumCond17;
    noNetworkInstruction.textAlignment = UITextAlignmentCenter;
    noNetworkInstruction.textColor = kPlndrMediumGreyTextColor;
    [self.view addSubview:noNetworkInstruction];
    
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *refreshButtonImage = [UIImage imageNamed:@"black_btn.png"];
    refreshButton.frame = CGRectMake((kDeviceWidth - refreshButtonImage.size.width)/2, noNetworkInstruction.frame.origin.y + noNetworkInstruction.frame.size.height + 4*kConnectionErrorVerticalPadding, refreshButtonImage.size.width, refreshButtonImage.size.height);
    [refreshButton setTitle:@"REFRESH" forState:UIControlStateNormal];
    [refreshButton setTitleColor:kPlndrWhite forState:UIControlStateNormal];
    refreshButton.titleLabel.font = kFontBoldCond17;
    [refreshButton setBackgroundImage:refreshButtonImage forState:UIControlStateNormal];
    [refreshButton setBackgroundImage:[UIImage imageNamed:@"black_btn_hl.png"] forState:UIControlStateHighlighted];
    [refreshButton addTarget:self action:@selector(refreshButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshButton];
    
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];  
}

- (void)setupNavBar {
    // Setup the left nav button
    UIButton *leftBtn = [PlndrBaseViewController createNavBarButtonWithText:@"CLOSE"];
    [leftBtn addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];   
}

- (void)cancelButtonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];   
}
-(void)refreshButtonClicked:(id)sender {
    [self showLoadingView];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshConnectionNetwork) userInfo:nil repeats:NO];

}

- (void)refreshConnectionNetwork {
    if (![Utility noNetworkConnection]) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self hideLoadingView];
    }
}

@end
