//
//  TDMFBLoginViewController.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 22/02/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMFBLoginViewController.h"

@implementation TDMFBLoginViewController
@synthesize webView;
@synthesize spinner;
@synthesize delegate = _delegate;
@synthesize apiKey = _apiKey;
@synthesize requestedPermissions = _requestedPermissions;

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setSpinner:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [webView release];
    [spinner release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (id)initWithAppId:(NSString *)apiKey requestedPermissions:(NSString *)requestedPermissions delegate:(id<TDMFacebookLoginDialogDelegate>)delegate {
    if ((self = [super initWithNibName:@"TDMFBLoginViewController" bundle:[NSBundle mainBundle]])) {
        self.apiKey = apiKey;
        self.requestedPermissions = requestedPermissions;
        self.delegate = delegate;
        
    }
    return self;    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark Login / Logout functions

- (void)login 
{   
    NSString *redirectUrlString = @"http://www.thedailymeal.com/";
    
    NSString *authFormatString = @"https://graph.facebook.com/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@&type=user_agent&display=touch";
    
    NSString *urlString = [NSString stringWithFormat:authFormatString, _apiKey,redirectUrlString, _requestedPermissions];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];	 
}


-(void)logout 
{    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookies deleteCookie:cookie];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType 
{
    
    NSString *urlString = request.URL.absoluteString;
    [self checkForAccessToken:urlString];    
    return TRUE;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView 
{
    [spinner stopAnimating];
//    spinner.hidden = YES;
}

#pragma mark Helper functions

-(void)checkForAccessToken:(NSString *)urlString 
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"access_token=(.*)&" options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
        if (firstMatch) {
            NSRange accessTokenRange = [firstMatch rangeAtIndex:1];
            NSString *accessToken = [urlString substringWithRange:accessTokenRange];
            accessToken = [accessToken stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [_delegate accessTokenFound:accessToken];               
        }
    }
}

-(void)checkLoginRequired:(NSString *)urlString 
{
    if ([urlString rangeOfString:@"login.php"].location != NSNotFound) 
    {
        [_delegate displayRequired];
    }
}

- (IBAction)closeTapped:(id)sender
{
     [_delegate closeTapped];
}

@end
