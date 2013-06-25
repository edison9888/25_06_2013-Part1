//
//  TwitterLoginPopup.m
//
//  Created by Jaanus Kase on 15.01.10.
//  Copyright 2010. All rights reserved.
//

#import "TwitterLoginPopup.h"
#import "OAuth.h"
#import "OAuth+UserDefaults.h"
#import "TwitterWebViewController.h"

@implementation TwitterLoginPopup

@synthesize webView;
@synthesize delegate, uiDelegate, oAuth;

#pragma mark Button actions

//change as void
- (void)getPin:(id)sender {
	
	iLoadCount=0;
	[[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	//self.view.frame=presentController.view.frame;
	m_objActivity1=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	m_objActivity1.frame=CGRectMake(0, 0, 20, 20);
	m_objActivity1.center = self.view.center;
	[m_objActivity1 startAnimating];
	[self.view addSubview:m_objActivity1];
	[m_objActivity1 release];
	
	[self startSession];
    
    getPinButton.enabled = NO;
    getPinButton.alpha = 0.5;
		
	[self.uiDelegate tokenRequestDidStart:self];
	
	
	NSInvocationOperation *operation = [[NSInvocationOperation alloc]
										initWithTarget:oAuth
										selector:@selector(synchronousRequestTwitterToken)
										object:nil];
	
	[queue addOperation:operation];
	[operation release];
}

- (void)savePin:(id)sender {
    [pinField resignFirstResponder];
    
	// delegate authorizationRequestDidStart
	[self.uiDelegate authorizationRequestDidStart:self];

	NSInvocationOperation *operation = [[NSInvocationOperation alloc]
										initWithTarget:oAuth
										selector:@selector(synchronousAuthorizeTwitterTokenWithVerifier:)
										object:authPin];
	[queue addOperation:operation];
	[operation release];
}

- (void) seePinAgain {
 	if (pinField.editing) {
		[pinField resignFirstResponder];
	}
	willBeEditingPin = YES;
    [[self navigationController] pushViewController:webViewController animated:YES];
}

- (void)cancel {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self]; // fix?
	[self.delegate twitterLoginPopupDidCancel:self];
}

#pragma mark -
#pragma mark OAuthTwitterCallbacks protocol

// For all of these methods, we invoked oAuth in a background thread, so these are also called
// in background thread. So we first transfer the control back to main thread before doing
// anything else.

- (void) requestTwitterTokenDidSucceed:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(requestTwitterTokenDidSucceed:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
    

	NSURL *myURL = [NSURL URLWithString:[NSString
										 stringWithFormat:@"https://api.twitter.com/oauth/authenticate?oauth_token=%@&force_login=true",
										 _oAuth.oauth_token]];
/*	NSURL *myURL = [NSURL URLWithString:[NSString
										 stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@",
										 _oAuth.oauth_token]];*/
	
	if (!webViewController) {
		webViewController = [[TwitterWebViewController alloc] initWithNibName:nil bundle:nil];
     /*   
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Enter PIN" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        [backButton release];
	  */
        webViewController.managingVc = self;
        
	}
	
	if (!self.webView) {
        
		//webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,-20,300,380)];
        UIWebView *webViewCreate = [[UIWebView alloc] initWithFrame:self.view.frame];
       // webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);    
		
        self.webView = webViewCreate;
        [webViewCreate release];
                
		[webViewController.view addSubview:self.webView];
		self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
        self.webView.scalesPageToFit = YES;
        self.webView.delegate = self;
	}
        
	//[[self navigationController] pushViewController:webViewController animated:YES];
	[self.view addSubview:webViewController.view];
	[self.webView loadRequest:[NSURLRequest requestWithURL:myURL]];
	/*
	UIBarButtonItem *forward = [[UIBarButtonItem alloc] initWithTitle:@"See PIN >"
																style:UIBarButtonItemStyleBordered
															   target:self
															   action:@selector(seePinAgain)];
	self.navigationItem.rightBarButtonItem = forward;
	[forward release];
	 */
	willBeEditingPin = YES;

	[self.uiDelegate tokenRequestDidSucceed:self];
}



- (void) requestTwitterTokenDidFail:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(requestTwitterTokenDidFail:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}

    // Re-enable the link to try again.
    getPinButton.enabled = YES;
    getPinButton.alpha = 1;
    
	[self.uiDelegate tokenRequestDidFail:self];
	
}

- (void) authorizeTwitterTokenDidSucceed:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(authorizeTwitterTokenDidSucceed:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}

	[self.uiDelegate authorizationRequestDidSucceed:self];
   [self.delegate twitterLoginPopupDidAuthorize:self];
	//modified
    [oAuth saveOAuthTwitterContextToUserDefaults];
	[[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[self.view removeFromSuperview];
	[webViewController.view removeFromSuperview];
}

- (void) authorizeTwitterTokenDidFail:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(authorizeTwitterTokenDidFail:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
    
	[self.uiDelegate authorizationRequestDidFail:self];	
}

#pragma mark -
#pragma mark UIViewController and memory mgmt


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    /*
	self.title = @"Sign In";
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
										  initWithTitle:@"Cancel"
										  style:UIBarButtonItemStylePlain
										  target:self
										  action:@selector(cancel)];	
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
    */
	[self startSession];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	self.navigationController.delegate = nil;
    if (queue) {
        [queue cancelAllOperations];
        [queue release];
        queue = nil;
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
    //return YES;
   return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
 // [self fixSignInButtonPositionWithOrientation:toInterfaceOrientation andAnimationDuration:duration];
}

// Re-layout interface after rotation
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  /*  CGRect signInButtonFrame = signInButton.frame;
    
    CGSize scrollContentSize = scrollView.contentSize;
    // 16px padding in bottom
    scrollContentSize.height = signInButtonFrame.origin.y + signInButtonFrame.size.height + 16;
    scrollContentSize.width = scrollView.frame.size.width;
    scrollView.contentSize = scrollContentSize;
    
    // Assume that we always want to focus on sign-in if this step is enabled
    [self focusPinField];   */ 
}


- (void)dealloc {
    
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
	
	self.webView = nil;
    
	[webViewController release];
    webViewController = nil;
    
	self.oAuth = nil;
    
	[pinField release];
    pinField = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark MyEdits

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil   {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        if (!webView) {
            
            //webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,-20,300,380)];
            UIWebView *newWebView = [[UIWebView alloc] init];
            // webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);    
            
            self.webView = newWebView;
            [newWebView release];
            newWebView = nil;

            self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
            self.webView.scalesPageToFit = YES;
            self.webView.delegate = self;
        }
    }
    return self;
}

-(void)startSession	{

    
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
    }
	
	
	oAuth.delegate = self;
	self.navigationController.delegate = self;    
    
    // disable step#2
    pinField.enabled = NO;
    signInButton.enabled = NO;
    signInButton.alpha = 0.5;
    typePinBelow.alpha = 0.5;
    signInBullet2.alpha = 0.5;
	
	// Listen for keyboard hide/show notifications so we can properly reconfigure the UI
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];        
    
    // XIB is done with portrait layout. If we were launched in landscape, this fixes the button positioning.
	[self fixSignInButtonPositionWithOrientation:self.interfaceOrientation andAnimationDuration:0];
	
}

-(void)setParentViewController:(id)controller	{
	
	presentController=controller;
}

- (NSString *) locateAuthPinInWebView: (UIWebView *) WebView {
	
    NSString            *js = @"var d = document.getElementById('oauth-pin'); if (d == null) d = document.getElementById('oauth_pin'); if (d) d = d.innerHTML; if (d == null) {var r = new RegExp('\\\\s[0-9]+\\\\s'); d = r.exec(document.body.innerHTML); if (d.length > 0) d = d[0];} d.replace(/^\\s*/, '').replace(/\\s*$/, ''); d;";
    NSString            *pin = [WebView stringByEvaluatingJavaScriptFromString: js];
	
	//    if (pin.length > 0) return pin;
	
    NSString            *html = [WebView stringByEvaluatingJavaScriptFromString: @"document.body.innerText"];
	NSLog(@"twitter response:%@",html);
	
	/********** checking for invalid username and password******/
	
	NSRange range1 = [html rangeOfString:@"Invalid user name or password" options:NSCaseInsensitiveSearch];
	NSRange rang2 = [html rangeOfString:@"Sign into Twitter" options:NSCaseInsensitiveSearch];
	if( range1.location != NSNotFound && rang2.location!=NSNotFound) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The Daily Meal" message:@"Invalid user name or password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
	/*	[[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
		[self.view removeFromSuperview];
		[webViewController.view removeFromSuperview];
		[self.view.superview removeFromSuperview];
		[presentController cancel];	*/
	}
	/********** checking for invalid username and password******/
	
    if (html.length == 0) return nil;
	
    const char            *rawHTML = (const char *) [html UTF8String];
    int                    length = strlen(rawHTML), chunkLength = 0;
	
    for (int i = 0; i < length; i++) {
        if (rawHTML[i] < '0' || rawHTML[i] > '9') {
            if (chunkLength == 7) {
                char                *buffer = (char *) malloc(chunkLength + 1);
				
                memmove(buffer, &rawHTML[i - chunkLength], chunkLength);
                buffer[chunkLength] = 0;
				
                pin = [NSString stringWithUTF8String: buffer];
                free(buffer);
                return pin;
            }
            chunkLength = 0;
        } else
            chunkLength++;
    }
	
    return nil;
}

#pragma mark -
#pragma mark Custom helpers, called from appropriate places in flow



- (void) focusPinField {
    if (signInButton.enabled) {
        CGRect scrollToFrame = signInButton.frame;
        scrollToFrame.origin.y += 16;
        [scrollView scrollRectToVisible:scrollToFrame animated:YES];        
    }
}

- (void) fixSignInButtonPositionWithOrientation:(UIDeviceOrientation)orientation andAnimationDuration:(NSTimeInterval)duration {
    CGRect signInButtonFrame = signInButton.frame;
    CGRect pinFieldFrame = pinField.frame;
    
    // If portrait, signin button is centered below the text field
    // If landscape, button is next to textfield
    if (!UIDeviceOrientationIsLandscape(orientation)) {
        signInButtonFrame.origin.y = pinFieldFrame.origin.y + 56;
        signInButtonFrame.origin.x = pinFieldFrame.origin.x + pinFieldFrame.size.width/2 - signInButtonFrame.size.width/2;        
    } else {
        signInButtonFrame.origin.y = pinFieldFrame.origin.y;
        signInButtonFrame.origin.x = pinFieldFrame.origin.x + pinFieldFrame.size.width + 8;
    }
    
    [UIView beginAnimations:@"RepositionSignInButton" context:nil];
    [UIView setAnimationDuration:duration];
    signInButton.frame = signInButtonFrame;
    [UIView commitAnimations];    
}

#pragma mark -
#pragma mark UINavigationController delegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == self) {
		if (willBeEditingPin) {
            [self fixSignInButtonPositionWithOrientation:self.interfaceOrientation andAnimationDuration:0];
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    // If user was looking at PIN in webview, activate the PIN text field and bring up keyboard.
	if (viewController == self) {
        
        getPinButton.enabled = YES;
        getPinButton.alpha = 1;
        
		if (willBeEditingPin) {
            
            pinField.enabled = YES;
            signInButton.enabled = YES;
            signInButton.alpha = 1;
            typePinBelow.alpha = 1;
            signInBullet2.alpha = 1;

			[pinField becomeFirstResponder];
            
            [self focusPinField];
		}
	}
}

#pragma mark -
#pragma mark Keyboard notifications

- (CGFloat)keyboardHeightFromNotification:(NSNotification *)aNotification {
    // http://stackoverflow.com/questions/2807339/uikeyboardboundsuserinfokey-is-deprecated-what-to-use-instead
    CGRect _keyboardEndFrame;
    [[aNotification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&_keyboardEndFrame];
    CGFloat _keyboardHeight;
    if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        _keyboardHeight = _keyboardEndFrame.size.height;
    }
    else {
        _keyboardHeight = _keyboardEndFrame.size.width;
    }
    
    return _keyboardHeight;
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
		
    CGRect scrollFrame = scrollView.frame;
    scrollFrame.size.height = self.view.frame.size.height - [self keyboardHeightFromNotification:aNotification];
    	
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    scrollView.frame = scrollFrame;
    [UIView commitAnimations];

}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    
    CGRect scrollFrame = scrollView.frame;
    scrollFrame.size.height = self.view.frame.size.height;
    
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    scrollView.frame = scrollFrame;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)WebView {

	m_objActivity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	m_objActivity.frame=CGRectMake(((WebView.frame.size.width / 2) -10), ((WebView.frame.size.height / 2) -10), 20, 20);
	[m_objActivity startAnimating];
	[WebView addSubview:m_objActivity];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	iLoadCount++;
	if(iLoadCount==2)	{
		//[[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
		//self.view.frame=presentController.view.frame;
		/*UIActivityIndicatorView *objActivity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		objActivity.frame=CGRectMake(190, 190, 20, 20);
		[objActivity startAnimating];
		[self.view addSubview:objActivity];
		[objActivity release];*/
		//[presentController.view addSubview:self.view];
		WebView.hidden=YES;
	}
	else if(iLoadCount>2){
		[[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
		//NSLog(@"Deny.....");
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)WebView {
	
	[m_objActivity removeFromSuperview];
	[m_objActivity release];
	m_objActivity=nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
	if(iLoadCount>=2){
		
		authPin=[self locateAuthPinInWebView:WebView];
		if(authPin)	{
			
			NSLog(@"Auth Pin  =  %@",authPin);
			[self savePin:nil];
			
			[[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
			[self.view removeFromSuperview];
			[webViewController.view removeFromSuperview];
			[self.view.superview removeFromSuperview];
			[presentController cancel];
		}
		else {
			
			WebView.hidden=NO;

		}

	}
}

@end
