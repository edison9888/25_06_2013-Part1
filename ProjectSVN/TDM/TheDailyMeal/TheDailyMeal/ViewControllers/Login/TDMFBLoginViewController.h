//
//  TDMFBLoginViewController.h
//  TheDailyMeal
//
//  Created by Aswathy Bose on 22/02/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TDMFacebookLoginDialogDelegate
@optional
- (void)accessTokenFound:(NSString *)apiKey;
- (void)displayRequired;
- (void)closeTapped;

@end

@interface TDMFBLoginViewController : UIViewController <UIWebViewDelegate>
{
    NSString *_apiKey;
    NSString *_requestedPermissions;
     id <TDMFacebookLoginDialogDelegate> _delegate;
    IBOutlet UIActivityIndicatorView *spinner;
}

@property (copy) NSString *apiKey;
@property (copy) NSString *requestedPermissions;
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (assign) id <TDMFacebookLoginDialogDelegate> delegate;


- (id)initWithAppId:(NSString *)apiKey requestedPermissions:(NSString *)requestedPermissions delegate:(id<TDMFacebookLoginDialogDelegate>)delegate;
- (IBAction)closeTapped:(id)sender;
- (void)login;
- (void)logout;

-(void)checkForAccessToken:(NSString *)urlString;
-(void)checkLoginRequired:(NSString *)urlString;
@end
